-- =====================================================
-- Source Column Auto-Population Triggers
-- Version: 1.0
-- Created: 2026-01-23
--
-- PURPOSE:
-- Automatically sets the 'source' column on INSERT for
-- tables where source is constant per table.
--
-- FUTURE NOTE:
-- The 'source' column may become redundant since each
-- table inherently represents a single source. These
-- triggers can be dropped if the source column is
-- removed in a future schema update.
--
-- TO REMOVE TRIGGERS (if no longer needed):
--   DROP TRIGGER IF EXISTS set_apparaat_source ON apparaat;
--   DROP TRIGGER IF EXISTS set_gemeente_source ON gemeente;
--   DROP TRIGGER IF EXISTS set_inkoop_source ON inkoop;
--   DROP TRIGGER IF EXISTS set_instrumenten_source ON instrumenten;
--   DROP TRIGGER IF EXISTS set_provincie_source ON provincie;
--   DROP FUNCTION IF EXISTS set_source_apparaat();
--   DROP FUNCTION IF EXISTS set_source_gemeente();
--   DROP FUNCTION IF EXISTS set_source_inkoop();
--   DROP FUNCTION IF EXISTS set_source_instrumenten();
--   DROP FUNCTION IF EXISTS set_source_provincie();
-- =====================================================

-- =====================================================
-- 1. APPARAAT - "Apparaatsuitgaven"
-- =====================================================
CREATE OR REPLACE FUNCTION set_source_apparaat()
RETURNS TRIGGER AS $$
BEGIN
  NEW.source := 'Apparaatsuitgaven';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_apparaat_source ON apparaat;
CREATE TRIGGER set_apparaat_source
  BEFORE INSERT ON apparaat
  FOR EACH ROW
  EXECUTE FUNCTION set_source_apparaat();

-- =====================================================
-- 2. GEMEENTE - "Gemeentelijke subsidieregisters"
-- =====================================================
CREATE OR REPLACE FUNCTION set_source_gemeente()
RETURNS TRIGGER AS $$
BEGIN
  NEW.source := 'Gemeentelijke subsidieregisters';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_gemeente_source ON gemeente;
CREATE TRIGGER set_gemeente_source
  BEFORE INSERT ON gemeente
  FOR EACH ROW
  EXECUTE FUNCTION set_source_gemeente();

-- =====================================================
-- 3. INKOOP - "Inkoopuitgaven"
-- =====================================================
CREATE OR REPLACE FUNCTION set_source_inkoop()
RETURNS TRIGGER AS $$
BEGIN
  NEW.source := 'Inkoopuitgaven';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_inkoop_source ON inkoop;
CREATE TRIGGER set_inkoop_source
  BEFORE INSERT ON inkoop
  FOR EACH ROW
  EXECUTE FUNCTION set_source_inkoop();

-- =====================================================
-- 4. INSTRUMENTEN - "Financiële instrumenten"
-- =====================================================
CREATE OR REPLACE FUNCTION set_source_instrumenten()
RETURNS TRIGGER AS $$
BEGIN
  NEW.source := 'Financiële instrumenten';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_instrumenten_source ON instrumenten;
CREATE TRIGGER set_instrumenten_source
  BEFORE INSERT ON instrumenten
  FOR EACH ROW
  EXECUTE FUNCTION set_source_instrumenten();

-- =====================================================
-- 5. PROVINCIE - "Provinciale subsidieregisters"
-- =====================================================
CREATE OR REPLACE FUNCTION set_source_provincie()
RETURNS TRIGGER AS $$
BEGIN
  NEW.source := 'Provinciale subsidieregisters';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_provincie_source ON provincie;
CREATE TRIGGER set_provincie_source
  BEFORE INSERT ON provincie
  FOR EACH ROW
  EXECUTE FUNCTION set_source_provincie();

-- =====================================================
-- 6. PUBLIEK - No trigger (source varies: COA, NWO, RVO, ZonMW)
-- =====================================================
-- The publiek table has multiple sources per record,
-- so no automatic trigger is applied.

-- =====================================================
-- VERIFICATION
-- =====================================================
SELECT
  tgname as trigger_name,
  relname as table_name,
  proname as function_name
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
JOIN pg_proc p ON t.tgfoid = p.oid
WHERE tgname LIKE 'set_%_source'
ORDER BY table_name;
