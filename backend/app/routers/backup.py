from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from core.database import get_db
from core.security import get_current_user
from models.user import User
from models.backup import Backup
from schemas.backup import (
    BackupUploadRequest,
    BackupMetaResponse,
    BackupDownloadResponse,
)

router = APIRouter(prefix="/backup", tags=["backup"])


# ── POST /backup  ─────────────────────────────────────────────────────────────
# Creates or replaces the user's single backup slot.
# We keep only ONE backup per user (last-write-wins). This keeps storage
# predictable. Versioned history can be added later as a paid feature.
@router.post("", response_model=BackupMetaResponse, status_code=status.HTTP_200_OK)
async def upload_backup(
    body: BackupUploadRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    # Validate encrypted_data is non-empty and looks like base64
    if not body.encrypted_data or len(body.encrypted_data) < 24:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="encrypted_data is missing or too short.",
        )

    # Upsert: one backup row per user
    result = await db.execute(
        select(Backup).where(Backup.user_id == current_user.id)
    )
    backup = result.scalar_one_or_none()

    if backup:
        # Update existing
        backup.encrypted_data = body.encrypted_data
        backup.backup_version = body.backup_version
        backup.platform = body.platform
        backup.batch_word_count = body.batch_word_count
        backup.vault_word_count = body.vault_word_count
        backup.streak = body.streak
    else:
        # Create new
        backup = Backup(
            user_id=current_user.id,
            encrypted_data=body.encrypted_data,
            backup_version=body.backup_version,
            platform=body.platform,
            batch_word_count=body.batch_word_count,
            vault_word_count=body.vault_word_count,
            streak=body.streak,
        )
        db.add(backup)

    await db.flush()
    return BackupMetaResponse.model_validate(backup)


# ── GET /backup/meta  ─────────────────────────────────────────────────────────
# Returns lightweight metadata so the app can show "Last backup: X words, Y days ago"
# without downloading the full encrypted blob.
@router.get("/meta", response_model=BackupMetaResponse)
async def get_backup_meta(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Backup).where(Backup.user_id == current_user.id)
    )
    backup = result.scalar_one_or_none()

    if not backup:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No backup found for this user.",
        )

    return BackupMetaResponse.model_validate(backup)


# ── GET /backup  ──────────────────────────────────────────────────────────────
# Returns the full encrypted blob for restore.
# Called once on new device sign-in — not a frequent operation.
@router.get("", response_model=BackupDownloadResponse)
async def download_backup(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Backup).where(Backup.user_id == current_user.id)
    )
    backup = result.scalar_one_or_none()

    if not backup:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No backup found. Complete a session to create one.",
        )

    return BackupDownloadResponse.model_validate(backup)


# ── DELETE /backup  ───────────────────────────────────────────────────────────
# Called from "Delete Account" flow — wipes the cloud backup.
@router.delete("", status_code=status.HTTP_204_NO_CONTENT)
async def delete_backup(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Backup).where(Backup.user_id == current_user.id)
    )
    backup = result.scalar_one_or_none()
    if backup:
        await db.delete(backup)
    return None
