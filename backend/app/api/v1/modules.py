"""
Module endpoints - all 7 data modules.

Modules:
- instrumenten: Financiële Instrumenten (674K rows)
- apparaat: Apparaatsuitgaven (21K rows)
- inkoop: Inkoopuitgaven (636K rows)
- provincie: Provinciale subsidies (67K rows)
- gemeente: Gemeentelijke subsidies (126K rows)
- publiek: Publieke uitvoeringsorganisaties (115K rows)
- integraal: Cross-module search (universal_search)
"""
from typing import Optional
from enum import Enum

from fastapi import APIRouter, Query, HTTPException
from pydantic import BaseModel, Field

router = APIRouter()


# =============================================================================
# Enums and Models
# =============================================================================

class ModuleName(str, Enum):
    """Available data modules."""
    instrumenten = "instrumenten"
    apparaat = "apparaat"
    inkoop = "inkoop"
    provincie = "provincie"
    gemeente = "gemeente"
    publiek = "publiek"
    integraal = "integraal"


class SortOrder(str, Enum):
    """Sort order options."""
    asc = "asc"
    desc = "desc"


class AggregatedRow(BaseModel):
    """Aggregated row with year columns."""

    # Primary identifier (Ontvanger for most, Kostensoort for apparaat)
    primary_field: str
    primary_value: str

    # Year columns (dynamic based on available data)
    years: dict[int, Optional[float]] = Field(
        default_factory=dict,
        description="Year to amount mapping, e.g., {2020: 1000000, 2021: 1200000}"
    )

    # Totals
    totaal: float = 0

    # Row count for expansion
    row_count: int = 1

    # Cross-module indicator (for integraal)
    modules: Optional[list[str]] = None


class ModuleResponse(BaseModel):
    """Standard response for module queries."""

    success: bool = True
    module: str
    data: list[AggregatedRow]
    meta: dict = Field(default_factory=dict)


class ErrorResponse(BaseModel):
    """Error response."""

    success: bool = False
    error: str
    details: Optional[dict] = None


# =============================================================================
# Endpoints
# =============================================================================

@router.get("", response_model=list[str])
async def list_modules():
    """List all available modules."""
    return [m.value for m in ModuleName]


@router.get("/{module}", response_model=ModuleResponse)
async def get_module_data(
    module: ModuleName,
    # Search
    q: Optional[str] = Query(None, min_length=1, max_length=200, description="Search query"),
    # Pagination
    limit: int = Query(25, ge=1, le=100, description="Results per page"),
    offset: int = Query(0, ge=0, description="Pagination offset"),
    # Filtering
    jaar: Optional[int] = Query(None, ge=2016, le=2025, description="Filter by year"),
    min_bedrag: Optional[float] = Query(None, ge=0, description="Minimum amount"),
    max_bedrag: Optional[float] = Query(None, ge=0, description="Maximum amount"),
    # Sorting
    sort_by: str = Query("totaal", description="Sort field"),
    sort_order: SortOrder = Query(SortOrder.desc, description="Sort direction"),
    # Grouping (for expandable rows)
    group_by: Optional[str] = Query(None, description="Group results by field"),
):
    """
    Get aggregated data for a module.

    Returns rows aggregated by recipient (or kostensoort for apparaat),
    with year columns showing amounts per year.

    ## Query Parameters

    - **q**: Search query (searches recipient/kostensoort and related fields)
    - **limit/offset**: Pagination (max 100 per page)
    - **jaar**: Filter to specific year
    - **min_bedrag/max_bedrag**: Filter by amount range
    - **sort_by**: Field to sort by (default: totaal)
    - **sort_order**: asc or desc (default: desc)
    - **group_by**: Group expanded rows by field (e.g., regeling, artikel)

    ## Response

    Returns aggregated rows with:
    - Primary field (ontvanger or kostensoort)
    - Year columns (2016-2024)
    - Total amount
    - Row count (for expansion indicator)
    """
    # TODO: Implement actual database query
    # This is a placeholder response

    return ModuleResponse(
        success=True,
        module=module.value,
        data=[
            AggregatedRow(
                primary_field="ontvanger" if module != ModuleName.apparaat else "kostensoort",
                primary_value="ProRail B.V." if module != ModuleName.apparaat else "Personeel",
                years={
                    2020: 100000000,
                    2021: 120000000,
                    2022: 115000000,
                    2023: 130000000,
                    2024: 145000000,
                },
                totaal=610000000,
                row_count=42,
                modules=["instrumenten", "publiek"] if module == ModuleName.integraal else None,
            )
        ],
        meta={
            "total": 1,
            "limit": limit,
            "offset": offset,
            "query": q,
            "filters": {
                "jaar": jaar,
                "min_bedrag": min_bedrag,
                "max_bedrag": max_bedrag,
            },
        },
    )


@router.get("/{module}/{primary_value}/details")
async def get_row_details(
    module: ModuleName,
    primary_value: str,
    group_by: Optional[str] = Query(None, description="Group by field"),
    jaar: Optional[int] = Query(None, ge=2016, le=2025, description="Filter by year"),
):
    """
    Get expanded details for a specific row.

    Returns the individual line items that make up an aggregated row,
    optionally grouped by a field (e.g., regeling, artikel).

    Used when user clicks to expand a row in the table.
    """
    # TODO: Implement actual database query

    return {
        "success": True,
        "module": module.value,
        "primary_value": primary_value,
        "group_by": group_by,
        "details": [
            {
                "id": 1,
                "regeling": "Beheer en onderhoud spoor",
                "artikel": "13 Spoorwegen",
                "years": {2023: 50000000, 2024: 55000000},
                "totaal": 105000000,
            },
            {
                "id": 2,
                "regeling": "Investeringen spoor",
                "artikel": "17 Megaprojecten",
                "years": {2023: 80000000, 2024: 90000000},
                "totaal": 170000000,
            },
        ],
    }
