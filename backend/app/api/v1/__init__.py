"""
API v1 router - combines all module endpoints.
"""
from fastapi import APIRouter

from app.api.v1.health import router as health_router
from app.api.v1.modules import router as modules_router

router = APIRouter()

# Health check
router.include_router(health_router, tags=["Health"])

# Module endpoints
router.include_router(modules_router, prefix="/modules", tags=["Modules"])
