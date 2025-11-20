-- ============================================
-- Supabase Tables Setup for Studio Forms
-- ============================================
-- This SQL script creates all necessary tables for the contact forms
-- Run this script in Supabase SQL Editor
-- ============================================

-- ============================================
-- Table 1: General Inquiries
-- ============================================
CREATE TABLE IF NOT EXISTS general_inquiries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================
-- Table 2: Commission Requests
-- ============================================
CREATE TABLE IF NOT EXISTS commission_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  purpose TEXT NOT NULL,
  recipient TEXT NOT NULL,
  size TEXT NOT NULL,
  medium TEXT NOT NULL,
  display_context TEXT NOT NULL,
  coa_registration TEXT NOT NULL,
  ownership_preference TEXT NOT NULL,
  additional_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================
-- Table 3: Appraisal Requests
-- ============================================
CREATE TABLE IF NOT EXISTS appraisal_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  collector_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  artwork_title TEXT NOT NULL,
  proof_file TEXT,
  condition_notes TEXT NOT NULL,
  appraisal_purpose TEXT NOT NULL,
  additional_info TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================
-- Table 4: Registry Enrollments
-- ============================================
CREATE TABLE IF NOT EXISTS registry_enrollments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  collector_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  address TEXT,
  owned_artworks TEXT NOT NULL,
  registry_consent TEXT NOT NULL,
  annual_appraisal TEXT NOT NULL,
  additional_notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================
-- Enable Row Level Security (RLS)
-- ============================================
ALTER TABLE general_inquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE commission_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE appraisal_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE registry_enrollments ENABLE ROW LEVEL SECURITY;

-- ============================================
-- Create Policies for Public Inserts
-- ============================================

-- Policy for general_inquiries
DROP POLICY IF EXISTS "Allow public inserts" ON general_inquiries;
CREATE POLICY "Allow public inserts" ON general_inquiries
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Policy for commission_requests
DROP POLICY IF EXISTS "Allow public inserts" ON commission_requests;
CREATE POLICY "Allow public inserts" ON commission_requests
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Policy for appraisal_requests
DROP POLICY IF EXISTS "Allow public inserts" ON appraisal_requests;
CREATE POLICY "Allow public inserts" ON appraisal_requests
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Policy for registry_enrollments
DROP POLICY IF EXISTS "Allow public inserts" ON registry_enrollments;
CREATE POLICY "Allow public inserts" ON registry_enrollments
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- ============================================
-- Optional: Create Indexes for Better Performance
-- ============================================
CREATE INDEX IF NOT EXISTS idx_general_inquiries_created_at ON general_inquiries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_general_inquiries_email ON general_inquiries(email);

CREATE INDEX IF NOT EXISTS idx_commission_requests_created_at ON commission_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_commission_requests_email ON commission_requests(email);

CREATE INDEX IF NOT EXISTS idx_appraisal_requests_created_at ON appraisal_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_appraisal_requests_email ON appraisal_requests(email);

CREATE INDEX IF NOT EXISTS idx_registry_enrollments_created_at ON registry_enrollments(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_registry_enrollments_email ON registry_enrollments(email);

-- ============================================
-- Verification Queries (Optional - for testing)
-- ============================================
-- Uncomment these to verify tables were created:
-- SELECT table_name FROM information_schema.tables 
-- WHERE table_schema = 'public' 
-- AND table_name IN ('general_inquiries', 'commission_requests', 'appraisal_requests', 'registry_enrollments');

-- ============================================
-- End of Script
-- ============================================

