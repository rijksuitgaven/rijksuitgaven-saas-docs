-- =====================================================
-- Backend API RLS Policies
-- Description: Allow backend (postgres role) to read data
-- Created: 2026-01-26
-- Execute: Run in Supabase SQL Editor
-- =====================================================

-- The backend API connects via pooler as 'postgres' role.
-- We need to allow this role to read all data tables.

-- Option 1: Add policies for postgres role (more secure)
-- This allows the backend to read, but not through direct Supabase client

-- Instrumenten
CREATE POLICY "Backend can read instrumenten" ON instrumenten
  FOR SELECT TO postgres USING (true);

-- Apparaat
CREATE POLICY "Backend can read apparaat" ON apparaat
  FOR SELECT TO postgres USING (true);

-- Inkoop
CREATE POLICY "Backend can read inkoop" ON inkoop
  FOR SELECT TO postgres USING (true);

-- Provincie
CREATE POLICY "Backend can read provincie" ON provincie
  FOR SELECT TO postgres USING (true);

-- Gemeente
CREATE POLICY "Backend can read gemeente" ON gemeente
  FOR SELECT TO postgres USING (true);

-- Publiek
CREATE POLICY "Backend can read publiek" ON publiek
  FOR SELECT TO postgres USING (true);

-- Universal Search
CREATE POLICY "Backend can read universal_search" ON universal_search
  FOR SELECT TO postgres USING (true);

-- =====================================================
-- Verify policies were created
-- =====================================================
-- SELECT tablename, policyname FROM pg_policies WHERE schemaname = 'public';
