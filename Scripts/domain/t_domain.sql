-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_domain;
create procedure pareto.t_domain()
language plpgsql
as $$
declare
 
  c_tenant_name constant varchar := 'system';
  c_schema_name constant varchar := 'system';
  
  c_test_name   constant varchar := 't_domain';
  c_name        constant varchar := 't_domain';
  c_description constant varchar := 't_description';
  c_username    constant varchar := 't_username';
  
  v_id          uuid;
  v_id_tenant   uuid;
  v_id_schema   uuid;
  v_response    pareto.response;
  
begin

  raise notice 'Test Domain Persist Beginning';

  -- ----------------------------------
  -- Get the 'system' tenant id
  -- ----------------------------------
  select id into v_id_tenant
    from pareto.tenant 
   where name = c_tenant_name;  
  assert v_id_tenant is not null, 'Test failed: System Tenant not found.';
  
  -- ----------------------------------
  -- Get the 'system' schema id
  -- ----------------------------------
  select id into v_id_schema
    from pareto.schema 
   where id_tenant = v_id_tenant  
     and name      = c_schema_name;  
  assert v_id_schema is not null, 'Test failed: System Schema not found.';
  
  -- ----------------------------------
  -- Clean if necessary
  -- ----------------------------------
  select id into v_id 
    from pareto.domain 
   where id_schema = v_id_schema
     and name = c_schema_name;
   
  if (v_id is not null) then
    raise notice 'WARNING: domain value "%" existed from a previous test. Deleting...', c_name;
    call pareto.d_domain(v_id, c_username, v_response);
    raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  end if;

  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_domain(v_id_schema, c_name, c_description, 'scott1', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_domain was not successful. See logs for details.';

  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_domain(v_response.id, c_name, c_description, 'scott2', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: u_domain was not successful. See logs for details.';

  -- ----------------------------------
  -- Deactivate (hide) a domain
  -- ----------------------------------
  call pareto.deact_domain(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: deact_domain was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Reactivate a domain
  -- ----------------------------------
  call pareto.react_domain(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: react_domain was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Search Domain by Alt Keys
  -- ----------------------------------
  select pareto.g_id_domain_alt_keys(c_tenant_name, c_schema_name, c_name) into v_id;
  assert v_id is not null, 'Test failed: g_id_domain_alt_keys failed to find the domain.';
  raise notice 'g_id_domain_alt_keys Successful';

  -- ----------------------------------
  -- Delete
  -- ----------------------------------
  call pareto.d_domain(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_domain was not successful. See logs for details.';
    
  raise notice 'Test Domain Completed';

end;
$$;

call pareto.t_domain();
drop procedure if exists pareto.t_domain;