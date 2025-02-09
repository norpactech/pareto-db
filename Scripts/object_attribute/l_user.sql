-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.l_system_commons_object;
create procedure pareto.l_system_commons_object()
language plpgsql
as $$
declare 

  c_tenant_name constant varchar := 'system';
  c_schema_name constant varchar := 'pareto';
  c_domain_name constant varchar := 'commons';
  c_object_name constant varchar := 'user';
  
  v_id_domain_object uuid;
  v_response         pareto.response;

begin

  raise notice 'Beginning User Attribute Load';

  -- ----------------------------------
  -- v_id_domain
  -- ----------------------------------
  select pareto.g_id_domain_object_alt_keys(c_tenant_name, c_schema_name, c_domain_name, c_object_name) into v_id_domain_object;
  assert v_id_domain_object is not null, 'Test failed: g_id_domain_object_alt_keys failed to find the domain object.';
  
  -- ----------------------------------
  -- Build System Commons Objects
  -- ----------------------------------
  call pareto.i_object_attribute(v_id_domain_object, 'id', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
  call pareto.i_object_attribute(v_id_domain_object, 'username', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
  call pareto.i_object_attribute(v_id_domain_object, 'email', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_object_attribute(v_id_domain_object, 'full_name', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_object_attribute(v_id_domain_object, 'created_at', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_object_attribute(v_id_domain_object, 'created_by', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_object_attribute(v_id_domain_object, 'updated_at', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_object_attribute(v_id_domain_object, 'updated_by', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_object_attribute(v_id_domain_object, 'is_active', null, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  raise notice 'Completed User Attribute Load';

end;
$$;

call pareto.l_system_commons_object();
drop procedure if exists pareto.l_system_commons_object;
