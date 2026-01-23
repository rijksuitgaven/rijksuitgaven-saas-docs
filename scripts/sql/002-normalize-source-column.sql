-- =====================================================
-- Normalize Source Column Values
-- Version: 1.0
-- Created: 2026-01-23
--
-- Run this script after every data import to ensure
-- consistent source column values across all tables.
-- =====================================================

-- 1. APPARAAT
UPDATE apparaat
SET source = 'Apparaatsuitgaven'
WHERE source IS NULL OR source != 'Apparaatsuitgaven';

-- 2. GEMEENTE
UPDATE gemeente
SET source = 'Gemeentelijke subsidieregisters'
WHERE source IS NULL OR source != 'Gemeentelijke subsidieregisters';

-- 3. INKOOP
UPDATE inkoop
SET source = 'Inkoopuitgaven'
WHERE source IS NULL OR source != 'Inkoopuitgaven';

-- 4. INSTRUMENTEN
UPDATE instrumenten
SET source = 'Financiële instrumenten'
WHERE source IS NULL OR source != 'Financiële instrumenten';

-- 5. PROVINCIE
UPDATE provincie
SET source = 'Provinciale subsidieregisters'
WHERE source IS NULL OR source != 'Provinciale subsidieregisters';

-- 6. PUBLIEK - No changes (already has correct source values per record)

-- =====================================================
-- Verification
-- =====================================================
SELECT 'apparaat' as table_name, source, COUNT(*) as rows FROM apparaat GROUP BY source
UNION ALL SELECT 'gemeente', source, COUNT(*) FROM gemeente GROUP BY source
UNION ALL SELECT 'inkoop', source, COUNT(*) FROM inkoop GROUP BY source
UNION ALL SELECT 'instrumenten', source, COUNT(*) FROM instrumenten GROUP BY source
UNION ALL SELECT 'provincie', source, COUNT(*) FROM provincie GROUP BY source
UNION ALL SELECT 'publiek', source, COUNT(*) FROM publiek GROUP BY source
ORDER BY table_name, source;
