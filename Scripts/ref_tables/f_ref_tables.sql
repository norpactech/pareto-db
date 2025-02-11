-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop function if exists pareto.g_id_ref_tables_alt_keys;
create function pareto.g_id_ref_tables_alt_keys(
  in in_tenant_name      varchar,
  in in_table_type_name  varchar,
  in in_table_value_name varchar
)
returns uuid
as $$

declare

  v_id_tenant         uuid;
  v_id_ref_table_type uuid;
  v_id_ref_tables     uuid;

begin

  select id into v_id_tenant
    from pareto.tenant
   where name = in_tenant_name;
  
  if (v_id_tenant is null) then
    raise exception 'Search failed: Tenant % not found', in_tenant_name;
  end if;

  select id into v_id_ref_table_type
    from pareto.ref_table_type
   where name = in_table_type_name;
  
  if (v_id_ref_table_type is null) then
    raise exception 'Search failed: Table Type % not found', in_table_type_name;
  end if;

  select id into v_id_ref_tables
    from pareto.ref_tables
   where id_tenant = v_id_tenant
     and id_ref_table_type = v_id_ref_table_type
     and value = in_table_value_name;

  if (v_id_ref_tables is null) then
    raise exception 'Search failed: Reference Table Value Name % not found', in_table_value_name;
  end if;
  
  return v_id_ref_tables;
  
end;
$$ language plpgsql;
