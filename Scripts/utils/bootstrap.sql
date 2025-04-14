-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- 
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Drop all dependent objects and recreate the schemas
-- ----------------------------------------------------------------------------

DROP SCHEMA IF EXISTS public cascade;
CREATE SCHEMA public AUTHORIZATION norpac;

DROP schema IF EXISTS pareto cascade;
CREATE schema pareto AUTHORIZATION norpac;

CREATE EXTENSION pldbgapi; -- Debugging

-- ----------------------------------------------------------------------------
-- Trigger function(s) in the Public Schema
-- ----------------------------------------------------------------------------

DROP FUNCTION IF EXISTS update_at() CASCADE;
CREATE FUNCTION update_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ----------------------------------------------------------------------------
-- Type(s) in the Public Schema
-- ----------------------------------------------------------------------------

DROP TYPE IF EXISTS pg_resp CASCADE;
CREATE TYPE pg_resp AS (
  status     TEXT,
  data       JSONB,
  errors     JSONB,
  error_code TEXT,
  message    TEXT,
  hint       TEXT,
  detail     TEXT
);

DROP TYPE IF EXISTS pareto.pg_resp CASCADE;
CREATE TYPE pareto.pg_resp AS (
  status     TEXT,
  data       JSONB,
  errors     JSONB,
  error_code TEXT,
  message    TEXT,
  hint       TEXT,
  detail     TEXT
);

DROP TYPE IF EXISTS pg_val CASCADE;
CREATE TYPE pg_val AS (
  passed  BOOLEAN,
  field   TEXT,
  message TEXT
);

DROP TYPE IF EXISTS pareto.pg_val CASCADE;
CREATE TYPE pareto.pg_val AS (
  passed  BOOLEAN,
  field   TEXT,
  message TEXT
);

-- ----------------------------------------------------------------------------
-- Logging
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.logs (  
  id           UUID DEFAULT gen_random_uuid(),
  created_at   TIMESTAMPTZ   DEFAULT CURRENT_TIMESTAMP,
  created_by   TEXT          DEFAULT 'unavailable',
  level        TEXT,
  message      TEXT,
  service_name TEXT,
  metadata JSONB default '{}'::JSONB
);

ALTER TABLE pareto.logs
  ADD PRIMARY KEY (id);

CREATE INDEX logs_created_at   ON pareto.logs (created_at DESC);
CREATE INDEX logs_level        ON pareto.logs (level);
CREATE INDEX logs_service_name ON pareto.logs (service_name);

-- Insert Logs

CREATE PROCEDURE pareto.i_logs(
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

  INSERT INTO pareto.logs (
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