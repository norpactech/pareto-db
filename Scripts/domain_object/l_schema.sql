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

  c_tenant_name constant varchar := 'system';
  c_schema_name constant varchar := 'pareto';
  c_domain_name constant varchar := 'schema';
  
  v_id_domain uuid;
  v_id_object uuid;
  v_response  pareto.response;

begin

  raise notice 'Beginning System Commons Object Load';

  -- ----------------------------------
  -- v_id_domain
  -- ----------------------------------
  select pareto.g_id_domain_alt_keys(c_tenant_name, c_schema_name, c_domain_name) into v_id_domain;
  assert v_id_domain is not null, 'Test failed: g_id_domain_alt_keys failed to find the domain.';
  
  -- ----------------------------------
  -- Build System Commons Objects
  -- ----------------------------------
  call pareto.i_domain_object(v_id_domain, 'schema', 'Schema',  true, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_domain_object(v_id_domain, 'domain', 'Domain',  true, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
  call pareto.i_domain_object(v_id_domain, 'domain_object', 'Domain',  true, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
  call pareto.i_domain_object(v_id_domain, 'attribute', 'Attribute',  true, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_domain_object(v_id_domain, 'index', 'Index', 'scott',  true, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_domain_object(v_id_domain, 'constraint', 'Constraint',  true, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
  raise notice 'Completed System Commons Object Load';

end;
$$;

call pareto.l_schema();
drop procedure if exists pareto.l_schema;
