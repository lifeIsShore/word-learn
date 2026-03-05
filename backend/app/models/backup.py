import uuid
from datetime import datetime, timezone

from sqlalchemy import String, DateTime, Text, Integer
from sqlalchemy.orm import Mapped, mapped_column

from core.database import Base


class Backup(Base):
    __tablename__ = "backups"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        String(36), nullable=False, index=True
    )

    # AES-256-GCM encrypted + gzip compressed JSON blob (base64-encoded)
    encrypted_data: Mapped[str] = mapped_column(Text, nullable=False)

    # Metadata — stored in plaintext so we can surface it to the user
    # without decrypting the full blob
    backup_version: Mapped[int] = mapped_column(Integer, nullable=False, default=1)
    platform: Mapped[str] = mapped_column(String(10), nullable=False, default="flutter")
    batch_word_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    vault_word_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    streak: Mapped[int] = mapped_column(Integer, nullable=False, default=0)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=lambda: datetime.now(timezone.utc)
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    def __repr__(self) -> str:
        return f"<Backup user={self.user_id} words={self.batch_word_count}>"
