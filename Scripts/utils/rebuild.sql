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

-- ----------------------------------------------------------------------------
-- PostgREST Users
-- ----------------------------------------------------------------------------

do $$ 
begin
  if not exists(select 1 from pg_roles where rolname = 'web_anon') then
    create role web_anon nologin;
  end if;

  if not exists(select 1 from pg_roles where rolname = 'web_update') then
    create role web_update nologin;
  end if;

end $$;

-- web_anon
grant usage on schema pareto to web_anon;
grant select on all tables in schema pareto to web_anon;

-- web_update
grant usage on schema pareto TO web_update;
grant all privileges on all tables in schema pareto to web_update;
grant all privileges on all functions in schema pareto to web_update;
