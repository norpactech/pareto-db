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
    create role web_update login password 'password';
  else
    alter role web_update login password 'password';
  end if;

  -- Create a superuser role for admin operations that bypass RLS
  if not exists(select 1 from pg_roles where rolname = 'web_admin') then
    create role web_admin login password 'password' bypassrls;
  else
    alter role web_admin login password 'password';
    -- Note: bypassrls can only be set during role creation or by superuser
  end if;

end $$;

-- web_anon - read-only access for unauthenticated users
grant usage on schema pareto to web_anon;
grant select on all tables in schema pareto to web_anon;
alter default privileges in schema pareto grant select on tables to web_anon;
alter default privileges in schema pareto grant usage, select on sequences to web_anon;

-- web_update - normal application user with RLS enforced
grant usage on schema pareto TO web_update;
grant select, insert, update, delete on all tables in schema pareto to web_update;
grant execute on all functions in schema pareto to web_update;
grant usage, select on all sequences in schema pareto to web_update;
alter default privileges in schema pareto grant select, insert, update, delete on tables to web_update;
alter default privileges in schema pareto grant usage, select on sequences to web_update;
alter default privileges in schema pareto grant execute on functions to web_update;

-- web_admin - administrative user that can bypass RLS for global operations
grant usage on schema pareto TO web_admin;
grant select, insert, update, delete on all tables in schema pareto to web_admin;
grant execute on all functions in schema pareto to web_admin;
grant usage, select on all sequences in schema pareto to web_admin;
grant create on schema pareto to web_admin;
alter default privileges in schema pareto grant select, insert, update, delete on tables to web_admin;
alter default privileges in schema pareto grant usage, select on sequences to web_admin;
alter default privileges in schema pareto grant execute on functions to web_admin;

grant connect on database norpac to web_anon;
grant connect on database norpac to web_update;
grant connect on database norpac to web_admin;