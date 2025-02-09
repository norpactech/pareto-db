-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_object_attribute;
create procedure pareto.t_object_attribute()
language plpgsql
as $$
declare
 
  c_tenant_name constant varchar := 'system';
  c_schema_name constant varchar := 'system';
  c_domain_name constant varchar := 'commons';
  c_object_name constant varchar := 'tester';
  
  c_test_name   constant varchar := 't_object_attribute';
  c_name        constant varchar := 't_object_attribute';
  c_description constant varchar := 't_description';
  c_username    constant varchar := 't_username';
  
  v_id                  uuid;
  v_id_domain           uuid;
  v_id_domain_object    uuid;
  v_id_object_attribute uuid;
  v_response    pareto.response;
  
begin

  raise notice 'Test object_attribute Persist Beginning';

  -- ----------------------------------
  -- v_id_domain
  -- ----------------------------------
  select pareto.g_id_domain_alt_keys(c_tenant_name, c_schema_name, c_domain_name) into v_id_domain;
  assert v_id_domain is not null, 'Test failed: g_id_domain_alt_keys failed to find the domain.';

  -- ----------------------------------
  -- Clean if necessary
  -- ----------------------------------
  select id into v_id_domain_object 
    from pareto.domain_object
   where id_domain = v_id_domain
     and name = c_object_name;
   
  if (v_id_domain_object is not null) then
    raise notice 'WARNING: domain_object value "%" existed from a previous test. Deleting...', c_object_name;
    call pareto.d_domain_object(v_id_domain_object, c_username, v_response);
    raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  end if;

  -- ----------------------------------
  -- Create a test Object
  -- ----------------------------------
  call pareto.i_domain_object(v_id_domain, c_object_name, c_description, 'scott1', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_domain_object was not successful. See logs for details.';
  v_id_domain_object = v_response.id;
  raise notice 'Test Object Created';

  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_object_attribute(v_id_domain_object, c_name, c_description, 'scott1', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';

  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_object_attribute(v_response.id, c_name, c_description, 'scott2', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: u_object_attribute was not successful. See logs for details.';

  -- ----------------------------------
  -- Deactivate (hide) a object_attribute
  -- ----------------------------------
  call pareto.deact_object_attribute(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: deact_object_attribute was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Reactivate a object_attribute
  -- ----------------------------------
  call pareto.react_object_attribute(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: react_object_attribute was not successful. See logs for details.';
      
  -- ----------------------------------
  -- Delete
  -- ----------------------------------
  call pareto.d_object_attribute(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_object_attribute was not successful. See logs for details.';
 
  call pareto.d_domain_object(v_id_domain_object, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_domain_object was not successful. See logs for details.';
  
  raise notice 'Test object_attribute Completed';

end;
$$;

call pareto.t_object_attribute();
drop procedure if exists pareto.t_object_attribute;