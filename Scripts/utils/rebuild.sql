-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Drop all dependent objects and recreate the schema
-- ----------------------------------------------------------------------------

drop schema if exists pareto cascade;
create schema pareto authorization norpac;

-- ----------------------------------------------------------------------------
-- Trigger function(s)
-- ----------------------------------------------------------------------------

create function pareto.update_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ----------------------------------------------------------------------------
-- Type(s)
-- ----------------------------------------------------------------------------

create type pareto.response AS (
  success boolean,
  id uuid,
  updated timestamp,
  message text
);