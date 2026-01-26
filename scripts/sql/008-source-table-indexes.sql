-- =====================================================
-- Source Table Indexes for Details/Drill-down Queries
-- Description: Faster queries when expanding rows to see details
-- Created: 2026-01-26
-- Executed: [Date] on [Environment]
-- =====================================================

-- These indexes speed up the /details endpoint which queries
-- source tables filtered by primary field (ontvanger/leverancier/kostensoort)

-- =====================================================
-- Instrumenten (674K rows)
-- Details query: WHERE ontvanger = $1
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_instrumenten_ontvanger_details
ON instrumenten (ontvanger);

-- Also index year field for year-filtered details
CREATE INDEX IF NOT EXISTS idx_instrumenten_begrotingsjaar
ON instrumenten (begrotingsjaar);

-- Composite index for filtered details (ontvanger + year)
CREATE INDEX IF NOT EXISTS idx_instrumenten_ontvanger_jaar
ON instrumenten (ontvanger, begrotingsjaar);

-- =====================================================
-- Apparaat (21K rows)
-- Details query: WHERE kostensoort = $1
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_apparaat_kostensoort_details
ON apparaat (kostensoort);

CREATE INDEX IF NOT EXISTS idx_apparaat_begrotingsjaar
ON apparaat (begrotingsjaar);

CREATE INDEX IF NOT EXISTS idx_apparaat_kostensoort_jaar
ON apparaat (kostensoort, begrotingsjaar);

-- =====================================================
-- Inkoop (636K rows)
-- Details query: WHERE leverancier = $1
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_inkoop_leverancier_details
ON inkoop (leverancier);

CREATE INDEX IF NOT EXISTS idx_inkoop_jaar
ON inkoop (jaar);

CREATE INDEX IF NOT EXISTS idx_inkoop_leverancier_jaar
ON inkoop (leverancier, jaar);

-- =====================================================
-- Provincie (67K rows)
-- Details query: WHERE ontvanger = $1
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_provincie_ontvanger_details
ON provincie (ontvanger);

CREATE INDEX IF NOT EXISTS idx_provincie_jaar
ON provincie (jaar);

CREATE INDEX IF NOT EXISTS idx_provincie_ontvanger_jaar
ON provincie (ontvanger, jaar);

-- =====================================================
-- Gemeente (126K rows)
-- Details query: WHERE ontvanger = $1
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_gemeente_ontvanger_details
ON gemeente (ontvanger);

CREATE INDEX IF NOT EXISTS idx_gemeente_jaar
ON gemeente (jaar);

CREATE INDEX IF NOT EXISTS idx_gemeente_ontvanger_jaar
ON gemeente (ontvanger, jaar);

-- =====================================================
-- Publiek (115K rows)
-- Details query: WHERE ontvanger = $1
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_publiek_ontvanger_details
ON publiek (ontvanger);

CREATE INDEX IF NOT EXISTS idx_publiek_jaar
ON publiek (jaar);

CREATE INDEX IF NOT EXISTS idx_publiek_ontvanger_jaar
ON publiek (ontvanger, jaar);

-- =====================================================
-- Verify indexes were created
-- =====================================================
SELECT
    schemaname,
    tablename,
    indexname
FROM pg_indexes
WHERE tablename IN ('instrumenten', 'apparaat', 'inkoop', 'provincie', 'gemeente', 'publiek')
  AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;
