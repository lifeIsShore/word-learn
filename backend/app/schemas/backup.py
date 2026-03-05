from pydantic import BaseModel
from datetime import datetime


# ── Request ───────────────────────────────────────────────────────────────────

class BackupUploadRequest(BaseModel):
    """
    Sent by the Flutter app when saving a backup.
    encrypted_data: AES-256-GCM encrypted, gzip-compressed, base64-encoded JSON.
    """
    encrypted_data: str
    backup_version: int = 1
    platform: str = "flutter"
    # Plaintext metadata (no sensitive info — just for the UI)
    batch_word_count: int = 0
    vault_word_count: int = 0
    streak: int = 0


# ── Response ──────────────────────────────────────────────────────────────────

class BackupMetaResponse(BaseModel):
    """Lightweight response — does NOT include encrypted_data."""
    id: str
    backup_version: int
    platform: str
    batch_word_count: int
    vault_word_count: int
    streak: int
    updated_at: datetime

    model_config = {"from_attributes": True}


class BackupDownloadResponse(BaseModel):
    """Full response including the encrypted blob for restore."""
    id: str
    encrypted_data: str
    backup_version: int
    platform: str
    batch_word_count: int
    vault_word_count: int
    streak: int
    updated_at: datetime

    model_config = {"from_attributes": True}
