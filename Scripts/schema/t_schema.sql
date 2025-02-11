-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_schema;
create procedure pareto.t_schema()
language plpgsql
as $$
declare
 
  c_tenant_name constant varchar := 'system';
  c_test_name   constant varchar := 't_schema';
  c_name        constant varchar := 't_schema';
  c_description constant varchar := 't_description';
  c_username    constant varchar := 't_username';
  
  v_id          uuid;
  v_id_tenant   uuid;
  v_response    pareto.response;
  
begin

  raise notice 'Test schema Persist Beginning';

  -- ----------------------------------
  -- Get the 'system' tenant id
  -- ----------------------------------
  select id into v_id_tenant
    from pareto.tenant 
   where name = c_tenant_name;
  
  assert v_id_tenant is not null, 'Test failed: System Tenant not found.';
  
  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_schema(v_id_tenant, c_name, c_description, 'scott1', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_schema was not successful. See logs for details.';

  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_schema(v_response.id, c_name, c_description, 'scott2', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: u_schema was not successful. See logs for details.';

  -- ----------------------------------
  -- Deactivate (hide) a schema
  -- ----------------------------------
  call pareto.deact_schema(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: deact_schema was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Reactivate a schema
  -- ----------------------------------
  call pareto.react_schema(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: react_schema was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Delete
  -- ----------------------------------
  call pareto.d_schema(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_alt_schema was not successful. See logs for details.';

  rollback;
  raise notice 'Test schema Persist Completed';

end;
$$;

call pareto.t_schema();
drop procedure if exists pareto.t_schema;