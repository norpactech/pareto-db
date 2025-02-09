-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.l_schema;
create procedure pareto.l_schema()
language plpgsql
as $$
declare 

  c_tenant_system constant varchar := 'system';
  c_tenant_norpac constant varchar := 'norpac';
  
  c_schema_pareto constant varchar := 'pareto';
  c_schema_router constant varchar := 'router';
  
  v_id_tenant uuid;
  v_response  pareto.response;

begin

  -- ----------------------------------
  -- System Schema
  -- ----------------------------------
  
  select id into v_id_tenant
    from pareto.tenant
   where name = c_tenant_system;
  assert v_id_tenant is not null;

  call pareto.i_schema(v_id_tenant, c_schema_pareto, 'System Schema', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  -- ----------------------------------
  -- NorPac Schema
  -- ----------------------------------
  
  select id into v_id_tenant
    from pareto.tenant
   where name = c_tenant_norpac;
  assert v_id_tenant is not null;
    
  call pareto.i_schema(v_id_tenant, c_schema_router, 'Router Schema', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
end;
$$;

call pareto.l_schema();
drop procedure if exists pareto.l_schema;
