"""
Health check endpoints.
"""
from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.config import Settings, get_settings

router = APIRouter()


class HealthResponse(BaseModel):
    """Health check response."""

    status: str
    version: str
    database: str
    typesense: str


@router.get("/health", response_model=HealthResponse)
async def health_check(settings: Settings = Depends(get_settings)):
    """
    Health check endpoint.

    Returns status of API and connections to external services.
    """
    # TODO: Add actual database and Typesense connectivity checks
    db_status = "configured" if settings.database_url else "not_configured"
    ts_status = "configured" if settings.typesense_host else "not_configured"

    return HealthResponse(
        status="healthy",
        version=settings.app_version,
        database=db_status,
        typesense=ts_status,
    )
