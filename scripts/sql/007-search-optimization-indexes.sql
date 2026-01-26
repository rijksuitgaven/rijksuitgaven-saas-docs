-- =====================================================
-- Search Optimization: pg_trgm + GIN Indexes
-- Description: Faster ILIKE searches on large tables
-- Created: 2026-01-26
-- Executed: [Date] on [Environment]
-- =====================================================

-- Enable pg_trgm extension for trigram-based text search
-- This dramatically speeds up ILIKE queries with wildcards
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- =====================================================
-- GIN indexes for aggregated views (used by API)
-- These speed up ILIKE '%search%' queries
-- =====================================================

-- Integraal (universal_search) - 466K rows
CREATE INDEX IF NOT EXISTS idx_universal_search_ontvanger_trgm
ON universal_search USING gin (ontvanger gin_trgm_ops);

-- Inkoop aggregated - 208K rows
CREATE INDEX IF NOT EXISTS idx_inkoop_aggregated_leverancier_trgm
ON inkoop_aggregated USING gin (leverancier gin_trgm_ops);

-- Instrumenten aggregated - 221K rows
CREATE INDEX IF NOT EXISTS idx_instrumenten_aggregated_ontvanger_trgm
ON instrumenten_aggregated USING gin (ontvanger gin_trgm_ops);

-- Publiek aggregated - 63K rows
CREATE INDEX IF NOT EXISTS idx_publiek_aggregated_ontvanger_trgm
ON publiek_aggregated USING gin (ontvanger gin_trgm_ops);

-- Provincie aggregated - 26K rows
CREATE INDEX IF NOT EXISTS idx_provincie_aggregated_ontvanger_trgm
ON provincie_aggregated USING gin (ontvanger gin_trgm_ops);

-- Gemeente aggregated - 22K rows
CREATE INDEX IF NOT EXISTS idx_gemeente_aggregated_ontvanger_trgm
ON gemeente_aggregated USING gin (ontvanger gin_trgm_ops);

-- Apparaat aggregated - 759 rows (small, but for consistency)
CREATE INDEX IF NOT EXISTS idx_apparaat_aggregated_kostensoort_trgm
ON apparaat_aggregated USING gin (kostensoort gin_trgm_ops);

-- =====================================================
-- Verify indexes were created
-- =====================================================
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE indexname LIKE '%trgm%'
ORDER BY tablename;
