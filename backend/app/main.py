from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from core.config import get_settings
from core.database import create_all_tables
from routers import auth as auth_router
from routers import backup as backup_router
from routers import user as user_router
# Import all models so SQLAlchemy registers them before create_all_tables()
import models.user  # noqa: F401
import models.backup  # noqa: F401

settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: create tables
    await create_all_tables()
    yield
    # Shutdown: nothing needed (connection pool closes automatically)


app = FastAPI(
    title="WordLearn API",
    version="1.0.0",
    description="Self-hosted backend for the WordLearn vocabulary app.",
    lifespan=lifespan,
    docs_url="/docs",       # Swagger UI
    redoc_url="/redoc",     # ReDoc
)

# ── CORS ─────────────────────────────────────────────────────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Routers ───────────────────────────────────────────────────────────────────
app.include_router(auth_router.router, prefix="/api/v1")
app.include_router(backup_router.router, prefix="/api/v1")
app.include_router(user_router.router, prefix="/api/v1")


# ── Health check ─────────────────────────────────────────────────────────────
@app.get("/health", tags=["system"])
async def health():
    return {"status": "ok", "env": settings.app_env}
