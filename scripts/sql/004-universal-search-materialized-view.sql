-- =====================================================
-- Universal Search Materialized View
-- Version: 1.0
-- Created: 2026-01-23
--
-- PURPOSE:
-- Aggregated cross-module search for "Integraal zoeken"
-- One row per unique recipient with yearly totals
--
-- INCLUDES: instrumenten, inkoop, publiek, gemeente, provincie
-- EXCLUDES: apparaat (operational costs, no external recipients)
--
-- REFRESH: Run after data updates (every ~2 weeks)
--   REFRESH MATERIALIZED VIEW CONCURRENTLY universal_search;
-- =====================================================

-- Step 1: Drop existing table/view (will be replaced by materialized view)
DROP MATERIALIZED VIEW IF EXISTS universal_search CASCADE;
DROP TABLE IF EXISTS universal_search CASCADE;

-- Step 2: Create the materialized view
-- ALL AMOUNTS IN ABSOLUTE EUROS (€1 = 1)
CREATE MATERIALIZED VIEW universal_search AS

WITH combined_data AS (
    -- =========================================
    -- FINANCIËLE INSTRUMENTEN
    -- bedrag is in THOUSANDS (×1000), so multiply to get absolute euros
    -- =========================================
    SELECT
        UPPER(ontvanger) AS ontvanger_key,
        ontvanger AS ontvanger_display,
        'Financiële instrumenten' AS source,
        begrotingsjaar AS jaar,
        COALESCE(bedrag, 0)::BIGINT * 1000 AS bedrag_euros  -- ×1000 to absolute
    FROM instrumenten
    WHERE ontvanger IS NOT NULL AND ontvanger != ''

    UNION ALL

    -- =========================================
    -- INKOOPUITGAVEN
    -- totaal_avg is in ABSOLUTE euros
    -- =========================================
    SELECT
        UPPER(leverancier) AS ontvanger_key,
        leverancier AS ontvanger_display,
        'Inkoopuitgaven' AS source,
        jaar,
        COALESCE(totaal_avg, 0)::BIGINT AS bedrag_euros  -- already absolute
    FROM inkoop
    WHERE leverancier IS NOT NULL AND leverancier != ''

    UNION ALL

    -- =========================================
    -- PUBLIEK (RVO, COA, NWO, ZonMW)
    -- bedrag is in ABSOLUTE euros
    -- =========================================
    SELECT
        UPPER(ontvanger) AS ontvanger_key,
        ontvanger AS ontvanger_display,
        'Publiek' AS source,
        jaar,
        COALESCE(bedrag, 0)::BIGINT AS bedrag_euros  -- already absolute
    FROM publiek
    WHERE ontvanger IS NOT NULL AND ontvanger != ''

    UNION ALL

    -- =========================================
    -- GEMEENTELIJKE SUBSIDIEREGISTERS
    -- bedrag is in ABSOLUTE euros
    -- =========================================
    SELECT
        UPPER(ontvanger) AS ontvanger_key,
        ontvanger AS ontvanger_display,
        'Gemeentelijke subsidieregisters' AS source,
        jaar,
        COALESCE(bedrag, 0)::BIGINT AS bedrag_euros  -- already absolute
    FROM gemeente
    WHERE ontvanger IS NOT NULL AND ontvanger != ''

    UNION ALL

    -- =========================================
    -- PROVINCIALE SUBSIDIEREGISTERS
    -- bedrag is in ABSOLUTE euros
    -- =========================================
    SELECT
        UPPER(ontvanger) AS ontvanger_key,
        ontvanger AS ontvanger_display,
        'Provinciale subsidieregisters' AS source,
        jaar,
        COALESCE(bedrag, 0)::BIGINT AS bedrag_euros  -- already absolute
    FROM provincie
    WHERE ontvanger IS NOT NULL AND ontvanger != ''
)

SELECT
    ontvanger_key,
    -- Keep one display version (alphabetically first for consistency)
    MIN(ontvanger_display) AS ontvanger,
    -- Which modules this recipient appears in
    STRING_AGG(DISTINCT source, ', ' ORDER BY source) AS sources,
    COUNT(DISTINCT source) AS source_count,
    -- Pivot years into columns
    COALESCE(SUM(CASE WHEN jaar = 2016 THEN bedrag_euros END), 0) AS "2016",
    COALESCE(SUM(CASE WHEN jaar = 2017 THEN bedrag_euros END), 0) AS "2017",
    COALESCE(SUM(CASE WHEN jaar = 2018 THEN bedrag_euros END), 0) AS "2018",
    COALESCE(SUM(CASE WHEN jaar = 2019 THEN bedrag_euros END), 0) AS "2019",
    COALESCE(SUM(CASE WHEN jaar = 2020 THEN bedrag_euros END), 0) AS "2020",
    COALESCE(SUM(CASE WHEN jaar = 2021 THEN bedrag_euros END), 0) AS "2021",
    COALESCE(SUM(CASE WHEN jaar = 2022 THEN bedrag_euros END), 0) AS "2022",
    COALESCE(SUM(CASE WHEN jaar = 2023 THEN bedrag_euros END), 0) AS "2023",
    COALESCE(SUM(CASE WHEN jaar = 2024 THEN bedrag_euros END), 0) AS "2024",
    COALESCE(SUM(CASE WHEN jaar = 2025 THEN bedrag_euros END), 0) AS "2025",
    -- Total across all years
    COALESCE(SUM(bedrag_euros), 0) AS totaal
FROM combined_data
GROUP BY ontvanger_key;

-- Step 3: Create indexes for fast search
CREATE UNIQUE INDEX idx_universal_search_key ON universal_search(ontvanger_key);
CREATE INDEX idx_universal_search_ontvanger ON universal_search(ontvanger);
CREATE INDEX idx_universal_search_sources ON universal_search(sources);
CREATE INDEX idx_universal_search_totaal ON universal_search(totaal DESC);

-- Step 4: Create data freshness tracking table
DROP TABLE IF EXISTS data_freshness CASCADE;
CREATE TABLE data_freshness (
    id SERIAL PRIMARY KEY,
    source VARCHAR(100) NOT NULL,
    sub_source VARCHAR(100) DEFAULT '',  -- e.g., 'Amsterdam', 'Noord-Holland'
    year INTEGER NOT NULL,
    last_updated DATE NOT NULL DEFAULT CURRENT_DATE,
    is_complete BOOLEAN DEFAULT false,
    record_count INTEGER,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(source, sub_source, year)
);

-- Step 5: Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_data_freshness_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER data_freshness_updated
    BEFORE UPDATE ON data_freshness
    FOR EACH ROW
    EXECUTE FUNCTION update_data_freshness_timestamp();

-- =====================================================
-- VERIFICATION
-- =====================================================

-- Show row count
SELECT COUNT(*) AS total_recipients FROM universal_search;

-- Show sample data
SELECT ontvanger, sources, source_count, "2023", "2024", totaal
FROM universal_search
ORDER BY totaal DESC
LIMIT 10;

-- Show sources breakdown
SELECT sources, COUNT(*) as recipient_count
FROM universal_search
GROUP BY sources
ORDER BY recipient_count DESC
LIMIT 20;
