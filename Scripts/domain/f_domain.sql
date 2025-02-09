-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop function if exists pareto.g_id_domain_alt_keys;

create function pareto.g_id_domain_alt_keys(
  in in_tenant_name varchar,
  in in_schema_name varchar,
  in in_domain_name varchar
)
returns uuid
as $$

declare

  v_id_tenant uuid;
  v_id_schema uuid;
  v_id_domain uuid;

begin

  select id into v_id_tenant
    from pareto.tenant
   where name = in_tenant_name;
  
  if (v_id_tenant is null) then
    raise exception 'Search failed: Tenant % not found', in_tenant_name;
  end if;

  select id into v_id_schema
    from pareto.schema
   where id_tenant = v_id_tenant
     and name = in_schema_name;
  
  if (v_id_schema is null) then
    raise exception 'Search failed: Schema % not found', in_schema_name;
  end if;

  select id into v_id_domain
    from pareto.domain
   where id_schema = v_id_schema
     and name = in_domain_name;

  if (v_id_domain is null) then
    raise exception 'Search failed: Domain % not found', in_domain_name;
  end if;
  
  return v_id_domain;
  
end;
$$ language plpgsql;
