-- =====================================================
-- Rijksuitgaven.nl Database Schema
-- Version: 1.0
-- Created: 2026-01-21
-- Executed: 2026-01-21 on Supabase (kmdelrgtgglcrupprkqf)
-- =====================================================

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS vector;

-- =====================================================
-- 1. INSTRUMENTEN (Financiële Instrumenten)
-- =====================================================
CREATE TABLE instrumenten (
  id SERIAL PRIMARY KEY,
  begrotingsjaar INTEGER,
  begrotingshoofdstuk VARCHAR(255),
  begrotingsnaam VARCHAR(255),
  ris_ibos_nummer VARCHAR(255),
  artikel VARCHAR(255),
  artikelonderdeel VARCHAR(255),
  instrument VARCHAR(255),
  detail VARCHAR(255),
  regeling VARCHAR(255),
  ontvanger VARCHAR(255),
  bedrag INTEGER,
  kvk_nummer INTEGER,
  rechtsvorm VARCHAR(255),
  id_nummer INTEGER,
  register_id_nummer VARCHAR(255),
  plaats VARCHAR(255),
  bedrag_normalized BIGINT,
  source VARCHAR(50)
);

-- =====================================================
-- 2. APPARAAT (Apparaatsuitgaven)
-- =====================================================
CREATE TABLE apparaat (
  id SERIAL PRIMARY KEY,
  begrotingsjaar INTEGER,
  begrotingshoofdstuk VARCHAR(255),
  begrotingsnaam VARCHAR(255),
  ris_ibos_nummer VARCHAR(255),
  artikel VARCHAR(255),
  artikelonderdeel VARCHAR(255),
  instrument VARCHAR(255),
  detail VARCHAR(255),
  kostensoort VARCHAR(255),
  bedrag INTEGER,
  bedrag_normalized BIGINT,
  source VARCHAR(50)
);

-- =====================================================
-- 3. INKOOP (Inkoopuitgaven)
-- =====================================================
CREATE TABLE inkoop (
  id SERIAL PRIMARY KEY,
  jaar INTEGER,
  ministerie VARCHAR(255),
  leverancier VARCHAR(255),
  categorie TEXT,
  staffel INTEGER,
  totaal_avg DOUBLE PRECISION DEFAULT 0,
  source VARCHAR(50)
);

-- =====================================================
-- 4. PROVINCIE (Provinciale subsidies)
-- =====================================================
CREATE TABLE provincie (
  id SERIAL PRIMARY KEY,
  provincie VARCHAR(255),
  nummer VARCHAR(255),
  jaar INTEGER,
  ontvanger VARCHAR(255),
  omschrijving TEXT,
  bedrag INTEGER,
  source VARCHAR(50)
);

-- =====================================================
-- 5. GEMEENTE (Gemeentelijke subsidies) - was 'stad'
-- =====================================================
CREATE TABLE gemeente (
  id SERIAL PRIMARY KEY,
  gemeente VARCHAR(255),  -- was 'Stad'
  nummer VARCHAR(255),
  jaar INTEGER,
  ontvanger VARCHAR(255),
  omschrijving TEXT,
  bedrag INTEGER,
  beleidsterrein VARCHAR(255),
  beleidsnota TEXT,
  regeling VARCHAR(255),
  source VARCHAR(50)
);

-- =====================================================
-- 6. PUBLIEK (RVO, COA, NWO)
-- =====================================================
CREATE TABLE publiek (
  id SERIAL PRIMARY KEY,
  projectnummer VARCHAR(255),
  jaar INTEGER,
  omschrijving TEXT,
  ontvanger VARCHAR(255),
  kvk_nummer VARCHAR(50),
  regeling VARCHAR(255),
  bedrag INTEGER,
  locatie GEOMETRY(Point, 4326),  -- PostGIS point
  trefwoorden TEXT,
  sectoren VARCHAR(255),
  eu_besluit VARCHAR(100),
  source VARCHAR(30) NOT NULL,
  provincie VARCHAR(100),
  staffel VARCHAR(7),
  onderdeel VARCHAR(10)
);

-- =====================================================
-- 7. UNIVERSAL_SEARCH (Cross-module aggregated)
-- =====================================================
CREATE TABLE universal_search (
  id SERIAL PRIMARY KEY,
  ontvanger VARCHAR(255),
  sources TEXT,
  sub_sources TEXT,
  sub_sources_count INTEGER,
  source_count INTEGER,
  row_count INTEGER,
  "2016" DECIMAL(20,6),
  "2017" DECIMAL(20,6),
  "2018" DECIMAL(20,6),
  "2019" DECIMAL(20,6),
  "2020" DECIMAL(20,6),
  "2021" DECIMAL(20,6),
  "2022" DECIMAL(20,6),
  "2023" DECIMAL(20,6),
  "2024" DECIMAL(20,6),
  totaal DECIMAL(20,6)
);

-- =====================================================
-- 8. USER_PROFILES (for auth)
-- =====================================================
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  first_name TEXT,
  last_name TEXT,
  organisation TEXT,
  role TEXT,
  phone TEXT,
  subscription_type TEXT,  -- 'yearly', 'monthly'
  subscription_start DATE,
  subscription_end DATE,
  user_list TEXT,  -- 'Per jaar', 'Per maand', 'Prospects', 'Ex'
  created_at TIMESTAMP DEFAULT NOW(),
  preferences JSONB DEFAULT '{}'
);

-- =====================================================
-- INDEXES (for performance)
-- =====================================================

-- Instrumenten
CREATE INDEX idx_instrumenten_ontvanger ON instrumenten(ontvanger);
CREATE INDEX idx_instrumenten_jaar ON instrumenten(begrotingsjaar);
CREATE INDEX idx_instrumenten_regeling ON instrumenten(regeling);

-- Apparaat
CREATE INDEX idx_apparaat_kostensoort ON apparaat(kostensoort);
CREATE INDEX idx_apparaat_jaar ON apparaat(begrotingsjaar);

-- Inkoop
CREATE INDEX idx_inkoop_leverancier ON inkoop(leverancier);
CREATE INDEX idx_inkoop_jaar ON inkoop(jaar);
CREATE INDEX idx_inkoop_ministerie ON inkoop(ministerie);

-- Provincie
CREATE INDEX idx_provincie_ontvanger ON provincie(ontvanger);
CREATE INDEX idx_provincie_jaar ON provincie(jaar);
CREATE INDEX idx_provincie_provincie ON provincie(provincie);

-- Gemeente
CREATE INDEX idx_gemeente_ontvanger ON gemeente(ontvanger);
CREATE INDEX idx_gemeente_jaar ON gemeente(jaar);
CREATE INDEX idx_gemeente_gemeente ON gemeente(gemeente);

-- Publiek
CREATE INDEX idx_publiek_ontvanger ON publiek(ontvanger);
CREATE INDEX idx_publiek_jaar ON publiek(jaar);
CREATE INDEX idx_publiek_source ON publiek(source);

-- Universal Search
CREATE INDEX idx_universal_ontvanger ON universal_search(ontvanger);
CREATE INDEX idx_universal_sources ON universal_search(sources);

-- =====================================================
-- ROW LEVEL SECURITY (basic - authenticated users only)
-- =====================================================

-- Enable RLS on data tables
ALTER TABLE instrumenten ENABLE ROW LEVEL SECURITY;
ALTER TABLE apparaat ENABLE ROW LEVEL SECURITY;
ALTER TABLE inkoop ENABLE ROW LEVEL SECURITY;
ALTER TABLE provincie ENABLE ROW LEVEL SECURITY;
ALTER TABLE gemeente ENABLE ROW LEVEL SECURITY;
ALTER TABLE publiek ENABLE ROW LEVEL SECURITY;
ALTER TABLE universal_search ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can read all data
CREATE POLICY "Authenticated users can read instrumenten" ON instrumenten
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read apparaat" ON apparaat
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read inkoop" ON inkoop
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read provincie" ON provincie
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read gemeente" ON gemeente
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read publiek" ON publiek
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can read universal_search" ON universal_search
  FOR SELECT USING (auth.role() = 'authenticated');

-- Users can only read their own profile
CREATE POLICY "Users can read own profile" ON user_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON user_profiles
  FOR UPDATE USING (auth.uid() = id);
