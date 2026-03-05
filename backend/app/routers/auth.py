from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from core.database import get_db
from core.security import (
    hash_password,
    verify_password,
    create_access_token,
    create_refresh_token,
    decode_token,
    get_current_user,
)
from models.user import User
from schemas.auth import (
    SignUpRequest,
    SignInRequest,
    RefreshRequest,
    UpdateDisplayNameRequest,
    AuthResponse,
    TokenResponse,
    UserResponse,
)

router = APIRouter(prefix="/auth", tags=["auth"])


# ── POST /auth/signup ────────────────────────────────────────────────────────
@router.post("/signup", response_model=AuthResponse, status_code=status.HTTP_201_CREATED)
async def signup(body: SignUpRequest, db: AsyncSession = Depends(get_db)):
    # Check duplicate email
    result = await db.execute(select(User).where(User.email == body.email))
    if result.scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already registered. Sign in instead.",
        )

    user = User(
        email=body.email,
        hashed_password=hash_password(body.password),
        display_name=body.display_name.strip(),
    )
    db.add(user)
    await db.flush()  # get the generated id before commit

    access_token = create_access_token(user.id)
    refresh_token = create_refresh_token(user.id)

    # Store hashed refresh token so we can invalidate it on logout
    user.refresh_token_hash = hash_password(refresh_token)

    return AuthResponse(
        user=UserResponse.model_validate(user),
        tokens=TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
        ),
    )


# ── POST /auth/signin ────────────────────────────────────────────────────────
@router.post("/signin", response_model=AuthResponse)
async def signin(body: SignInRequest, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.email == body.email))
    user = result.scalar_one_or_none()

    if not user or not verify_password(body.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password.",
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Account is disabled.",
        )

    access_token = create_access_token(user.id)
    refresh_token = create_refresh_token(user.id)
    user.refresh_token_hash = hash_password(refresh_token)

    return AuthResponse(
        user=UserResponse.model_validate(user),
        tokens=TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
        ),
    )


# ── POST /auth/refresh ───────────────────────────────────────────────────────
@router.post("/refresh", response_model=TokenResponse)
async def refresh_tokens(body: RefreshRequest, db: AsyncSession = Depends(get_db)):
    payload = decode_token(body.refresh_token)

    if payload.get("type") != "refresh":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token type.",
        )

    user_id: str = payload.get("sub")
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()

    if not user or not user.refresh_token_hash:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Session expired. Please sign in again.",
        )

    # Verify the stored refresh token matches (prevents reuse after logout)
    if not verify_password(body.refresh_token, user.refresh_token_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Refresh token is invalid or has been revoked.",
        )

    access_token = create_access_token(user.id)
    new_refresh_token = create_refresh_token(user.id)
    user.refresh_token_hash = hash_password(new_refresh_token)

    return TokenResponse(
        access_token=access_token,
        refresh_token=new_refresh_token,
    )


# ── POST /auth/logout ────────────────────────────────────────────────────────
@router.post("/logout", status_code=status.HTTP_204_NO_CONTENT)
async def logout(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    # Revoke refresh token by clearing the hash
    current_user.refresh_token_hash = None
    return None


# ── GET /auth/me ─────────────────────────────────────────────────────────────
@router.get("/me", response_model=UserResponse)
async def get_me(current_user: User = Depends(get_current_user)):
    return UserResponse.model_validate(current_user)


# ── PATCH /auth/me ───────────────────────────────────────────────────────────
@router.patch("/me", response_model=UserResponse)
async def update_me(
    body: UpdateDisplayNameRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    current_user.display_name = body.display_name.strip()
    return UserResponse.model_validate(current_user)
