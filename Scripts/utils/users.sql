-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

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
grant select, insert, update, delete on all tables in schema pareto to web_update;
grant execute on all functions in schema pareto to web_update;



