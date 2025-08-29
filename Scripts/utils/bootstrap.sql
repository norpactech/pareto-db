-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- 
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Drop all dependent objects and recreate the schemas
-- ----------------------------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS public AUTHORIZATION norpac;

DROP schema IF EXISTS united_bins cascade;
CREATE SCHEMA IF NOT EXISTS united_bins AUTHORIZATION norpac;

CREATE EXTENSION IF NOT EXISTS pldbgapi; -- Debugging

-- ----------------------------------------------------------------------------
-- Public functions - Shared across all schemas
-- ----------------------------------------------------------------------------

-- Create or replace the public update_at function (shared by all schemas)
CREATE OR REPLACE FUNCTION public.update_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ----------------------------------------------------------------------------
-- Public types - Shared across all schemas  
-- ----------------------------------------------------------------------------

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'pg_resp' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'pareto')) THEN
    CREATE TYPE pareto.pg_resp AS (
      status     TEXT,
      data       JSONB,
      errors     JSONB,
      error_code TEXT,
      message    TEXT,
      hint       TEXT,
      detail     TEXT
  );
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'pg_val' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'pareto')) THEN
    CREATE TYPE pareto.pg_val AS (
      passed  BOOLEAN,
      field   TEXT,
      message TEXT
  );
  END IF;
END
$$;

-- ----------------------------------------------------------------------------
-- Logging
-- ----------------------------------------------------------------------------

CREATE TABLE united_bins.logs (  
  id           UUID DEFAULT gen_random_uuid(),
  created_at   TIMESTAMPTZ   DEFAULT CURRENT_TIMESTAMP,
  created_by   TEXT          DEFAULT 'unavailable',
  level        TEXT,
  message      TEXT,
  service_name TEXT,
  metadata JSONB default '{}'::JSONB
);

ALTER TABLE united_bins.logs
  ADD PRIMARY KEY (id);

CREATE INDEX logs_created_at   ON united_bins.logs (created_at DESC);
CREATE INDEX logs_level        ON united_bins.logs (level);
CREATE INDEX logs_service_name ON united_bins.logs (service_name);

-- Insert Logs

CREATE PROCEDURE united_bins.i_logs(
  IN in_level         TEXT,
  IN in_message       TEXT,
  IN in_service_name  TEXT,
  IN in_created_by    TEXT,
  IN in_metadata      JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN

  INSERT INTO united_bins.logs (
    level,
    message,
    service_name,
    created_by,
    metadata
  )
  VALUES (
    in_level,
    in_message,
    in_service_name,
    in_created_by,
    in_metadata
  );

END;
$$;