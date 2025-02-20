-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Drop all dependent objects and recreate the schemas
-- ----------------------------------------------------------------------------

drop schema if exists public cascade;
create schema public authorization norpac;

drop schema if exists pareto cascade;
create schema pareto authorization norpac;

-- ----------------------------------------------------------------------------
-- Trigger function(s)
-- ----------------------------------------------------------------------------

create function update_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ----------------------------------------------------------------------------
-- Type(s)
-- ----------------------------------------------------------------------------

CREATE TYPE pg_resp AS (
  status     TEXT,
  data       JSONB,
  errors     JSONB,
  error_code TEXT,
  message    TEXT,
  hint       TEXT,
  detail     TEXT
);

CREATE TYPE pg_val AS (
  passed  BOOLEAN,
  field   TEXT,
  message TEXT
);


