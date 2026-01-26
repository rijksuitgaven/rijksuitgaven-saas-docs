-- =====================================================
-- Entity Resolution: Recipient Name Normalization
-- Description: Normalizes recipient names to merge duplicates
-- Created: 2026-01-26
-- Executed: 2026-01-26 on Supabase
-- Result: 466,827 → 451,445 entities (15,382 duplicates merged)
-- =====================================================

-- =====================================================
-- Step 1: Create normalization function
-- Handles: casing, B.V./BV, N.V./NV, extra spaces
-- =====================================================

CREATE OR REPLACE FUNCTION normalize_recipient(name TEXT)
RETURNS TEXT AS $$
SELECT
  TRIM(
    REGEXP_REPLACE(
      REGEXP_REPLACE(
        REGEXP_REPLACE(
          REGEXP_REPLACE(
            REGEXP_REPLACE(
              REGEXP_REPLACE(
                REGEXP_REPLACE(
                  UPPER(TRIM(COALESCE(name, ''))),
                  '\s+', ' ', 'g'),              -- multiple spaces → single
                '\.+$', ''),                      -- trailing dots
              ' B\.V\.?$', ''),                   -- " B.V." or " B.V" at end
            ' BV\.?$', ''),                       -- " BV" at end
          ' N\.V\.?$', ''),                       -- " N.V." at end
        ' NV\.?$', ''),                           -- " NV" at end
      '^N\.V\.? ', '')                            -- "N.V. " at start
  );
$$ LANGUAGE SQL IMMUTABLE STRICT;

-- =====================================================
-- Step 2: Test the function
-- =====================================================

-- SELECT
--   normalize_recipient('N.V. Nederlandse Spoorwegen') as test1,  -- → NEDERLANDSE SPOORWEGEN
--   normalize_recipient('Nederlandse Spoorwegen') as test2,       -- → NEDERLANDSE SPOORWEGEN
--   normalize_recipient('NEDERLANDSE SPOORWEGEN N.V.') as test3,  -- → NEDERLANDSE SPOORWEGEN
--   normalize_recipient('NS Vastgoed B.V.') as test4,             -- → NS VASTGOED
--   normalize_recipient('NS Vastgoed BV') as test5,               -- → NS VASTGOED
--   normalize_recipient('ProRail B.V.') as test6,                 -- → PRORAIL
--   normalize_recipient('Prorail BV') as test7;                   -- → PRORAIL

-- =====================================================
-- Step 3: Rebuild universal_search with normalization
-- =====================================================

-- NOTE: Run these parts separately to avoid timeout

-- Part A: Drop existing view
-- DROP MATERIALIZED VIEW IF EXISTS universal_search;

-- Part B: Create view with normalization
CREATE MATERIALIZED VIEW universal_search AS
WITH combined_data AS (
    SELECT
        normalize_recipient(ontvanger) AS ontvanger_key,
        ontvanger AS ontvanger_display,
        'Financiële instrumenten'::text AS source,
        begrotingsjaar AS jaar,
        COALESCE(bedrag, 0)::bigint * 1000 AS bedrag_euros
    FROM instrumenten
    WHERE ontvanger IS NOT NULL AND ontvanger::text <> ''

    UNION ALL

    SELECT
        normalize_recipient(leverancier) AS ontvanger_key,
        leverancier AS ontvanger_display,
        'Inkoopuitgaven'::text AS source,
        jaar,
        COALESCE(totaal_avg, 0)::bigint AS bedrag_euros
    FROM inkoop
    WHERE leverancier IS NOT NULL AND leverancier::text <> ''

    UNION ALL

    SELECT
        normalize_recipient(ontvanger) AS ontvanger_key,
        ontvanger AS ontvanger_display,
        'Publiek'::text AS source,
        jaar,
        COALESCE(bedrag, 0)::bigint AS bedrag_euros
    FROM publiek
    WHERE ontvanger IS NOT NULL AND ontvanger::text <> ''

    UNION ALL

    SELECT
        normalize_recipient(ontvanger) AS ontvanger_key,
        ontvanger AS ontvanger_display,
        'Gemeentelijke subsidieregisters'::text AS source,
        jaar,
        COALESCE(bedrag, 0)::bigint AS bedrag_euros
    FROM gemeente
    WHERE ontvanger IS NOT NULL AND ontvanger::text <> ''

    UNION ALL

    SELECT
        normalize_recipient(ontvanger) AS ontvanger_key,
        ontvanger AS ontvanger_display,
        'Provinciale subsidieregisters'::text AS source,
        jaar,
        COALESCE(bedrag, 0)::bigint AS bedrag_euros
    FROM provincie
    WHERE ontvanger IS NOT NULL AND ontvanger::text <> ''
)
SELECT
    ontvanger_key,
    MIN(ontvanger_display) AS ontvanger,
    STRING_AGG(DISTINCT source, ', ' ORDER BY source) AS sources,
    COUNT(DISTINCT source) AS source_count,
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
    COALESCE(SUM(bedrag_euros), 0) AS totaal
FROM combined_data
GROUP BY ontvanger_key;

-- =====================================================
-- Step 4: Create indexes
-- =====================================================

CREATE INDEX idx_universal_search_ontvanger ON universal_search (ontvanger);
CREATE INDEX idx_universal_search_totaal ON universal_search (totaal DESC);
CREATE INDEX idx_universal_search_ontvanger_trgm ON universal_search USING gin (ontvanger gin_trgm_ops);
CREATE UNIQUE INDEX idx_universal_search_key ON universal_search (ontvanger_key);

-- =====================================================
-- Verification queries
-- =====================================================

-- Check row count
-- SELECT COUNT(*) FROM universal_search;
-- Expected: ~451,445 (down from 466,827)

-- Check NS merged
-- SELECT ontvanger, totaal, sources FROM universal_search
-- WHERE ontvanger_key LIKE '%SPOORWEGEN%' ORDER BY totaal DESC;

-- Check ProRail merged
-- SELECT ontvanger, totaal, sources FROM universal_search
-- WHERE ontvanger_key LIKE '%PRORAIL%' ORDER BY totaal DESC;
