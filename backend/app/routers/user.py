from datetime import datetime, timezone, timedelta

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete

from core.database import get_db
from core.security import get_current_user
from models.user import User
from models.backup import Backup

router = APIRouter(prefix="/user", tags=["user"])


# ── DELETE /user/delete ───────────────────────────────────────────────────────
# GDPR "Right to Erasure" (WL-410).
#
# Soft-delete strategy:
#   - Set is_active=False immediately (no new logins possible)
#   - Record scheduled_deletion_at = now + 30 days (for audit / recovery window)
#   - Wipe the backup blob immediately (no reason to keep encrypted data)
#   - Wipe the refresh token hash (invalidates all sessions)
#
# A background job (cron / Celery beat) should hard-delete users where
# scheduled_deletion_at < now. Until then the row stays for audit purposes.
@router.delete("/delete", status_code=status.HTTP_200_OK)
async def delete_account(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    # 1. Delete backup blob immediately.
    await db.execute(
        delete(Backup).where(Backup.user_id == current_user.id)
    )

    # 2. Soft-delete the user row.
    current_user.is_active = False
    current_user.refresh_token_hash = None  # revoke all sessions
    current_user.scheduled_deletion_at = datetime.now(timezone.utc) + timedelta(days=30)

    return {
        "message": "Account scheduled for deletion.",
        "deletion_date": current_user.scheduled_deletion_at.isoformat(),
    }
