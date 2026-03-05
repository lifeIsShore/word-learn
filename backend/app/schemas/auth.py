import re
from pydantic import BaseModel, EmailStr, field_validator


# ── Request schemas ──────────────────────────────────────────────────────────

class SignUpRequest(BaseModel):
    email: EmailStr
    password: str
    display_name: str = "Scholar"

    @field_validator("password")
    @classmethod
    def password_strength(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Password must be at least 8 characters.")
        if not re.search(r"[A-Z]", v):
            raise ValueError("Password must contain an uppercase letter.")
        if not re.search(r"\d", v):
            raise ValueError("Password must contain a number.")
        if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", v):
            raise ValueError("Password must contain a special character.")
        return v

    @field_validator("display_name")
    @classmethod
    def display_name_length(cls, v: str) -> str:
        v = v.strip()
        if len(v) < 1:
            raise ValueError("Display name cannot be empty.")
        if len(v) > 100:
            raise ValueError("Display name max 100 characters.")
        return v


class SignInRequest(BaseModel):
    email: EmailStr
    password: str


class RefreshRequest(BaseModel):
    refresh_token: str


class UpdateDisplayNameRequest(BaseModel):
    display_name: str

    @field_validator("display_name")
    @classmethod
    def not_empty(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("Display name cannot be empty.")
        return v


# ── Response schemas ─────────────────────────────────────────────────────────

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class UserResponse(BaseModel):
    id: str
    email: str
    display_name: str
    subscription_tier: str
    is_email_verified: bool

    model_config = {"from_attributes": True}


class AuthResponse(BaseModel):
    user: UserResponse
    tokens: TokenResponse
