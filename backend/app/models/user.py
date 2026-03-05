import uuid
from datetime import datetime, timezone

from sqlalchemy import String, Boolean, DateTime, Text
from sqlalchemy.orm import Mapped, mapped_column

from core.database import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False, index=True)
    hashed_password: Mapped[str] = mapped_column(Text, nullable=False)
    display_name: Mapped[str] = mapped_column(String(100), nullable=False, default="Scholar")

    # Subscription
    subscription_tier: Mapped[str] = mapped_column(
        String(20), nullable=False, default="free"
    )  # free | monthly | sixmonth

    # Account state
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_email_verified: Mapped[bool] = mapped_column(Boolean, default=False)

    # Refresh token — stored hashed so we can invalidate on logout
    refresh_token_hash: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Timestamps
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=lambda: datetime.now(timezone.utc)
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    def __repr__(self) -> str:
        return f"<User id={self.id} email={self.email}>"
