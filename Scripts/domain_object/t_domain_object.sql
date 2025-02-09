-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_domain_object;
create procedure pareto.t_domain_object()
language plpgsql
as $$
declare
 
  c_tenant_name constant varchar := 'system';
  c_schema_name constant varchar := 'system';
  c_domain_name constant varchar := 'commons';
  
  c_test_name   constant varchar := 't_domain_object';
  c_name        constant varchar := 't_domain_object';
  c_description constant varchar := 't_description';
  c_username    constant varchar := 't_username';
  
  v_id          uuid;
  v_id_tenant   uuid;
  v_id_schema   uuid;
  v_id_domain   uuid;
  v_response    pareto.response;
  
begin

  raise notice 'Test domain_object Persist Beginning';

  -- ----------------------------------
  -- v_id_domain
  -- ----------------------------------
  select pareto.g_id_domain_alt_keys(c_tenant_name, c_schema_name, c_domain_name) into v_id_domain;
  assert v_id_domain is not null, 'Test failed: g_id_domain_alt_keys failed to find the domain.';
  
  -- ----------------------------------
  -- Clean if necessary
  -- ----------------------------------
  select id into v_id 
    from pareto.domain_object 
   where id_domain = v_id_domain
     and name = c_name;
   
  if (v_id is not null) then
    raise notice 'WARNING: domain_object value "%" existed from a previous test. Deleting...', c_name;
    call pareto.d_domain_object(v_id, c_username, v_response);
    raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  end if;

  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_domain_object(v_id_domain, c_name, c_description, 'scott1', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_domain_object was not successful. See logs for details.';

  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_domain_object(v_response.id, c_name, c_description, 'scott2', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: u_domain_object was not successful. See logs for details.';

  -- ----------------------------------
  -- Deactivate (hide) a domain_object
  -- ----------------------------------
  call pareto.deact_domain_object(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: deact_domain_object was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Reactivate a domain_object
  -- ----------------------------------
  call pareto.react_domain_object(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: react_domain_object was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Search domain_object by Alt Keys
  -- ----------------------------------
  select pareto.g_id_domain_object_alt_keys(c_tenant_name, c_schema_name, c_domain_name, c_name) into v_id;
  assert v_id is not null, 'Test failed: g_id_domain_object_alt_keys failed to find the domain_object.';
  raise notice 'g_id_domain_object_alt_keys Successful';
    
  -- ----------------------------------
  -- Delete
  -- ----------------------------------
  call pareto.d_domain_object(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_domain_object was not successful. See logs for details.';
    
  raise notice 'Test domain_object Completed';

end;
$$;

call pareto.t_domain_object();
drop procedure if exists pareto.t_domain_object;