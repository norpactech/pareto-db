-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_tenant;
create procedure pareto.t_tenant()
language plpgsql
as $$
declare
 
  c_test_name   constant varchar := 't_tenant';
  c_name        constant varchar := 't_tenant';
  c_description constant varchar := 't_description';
  c_copyright   constant varchar := 't_copyright';
  c_username    constant varchar := 't_username';
  v_id          uuid;        
  v_response    pareto.response;
  
begin

  -- ----------------------------------
  -- Clean if necessary
  -- ----------------------------------
  select id into v_id 
    from pareto.tenant 
   where name = c_name;
   
  if (v_id is not null) then
    raise notice 'WARNING: tenant value "%" existed from a previous test. Deleting...', c_name;
    call pareto.d_tenant_by_alt_key(c_name, c_username, v_response);
    raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  end if;

  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_tenant(c_name, c_description, c_copyright, 'Scott1', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_tenant was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_tenant(v_response.id, c_name, c_description, c_copyright, 'Scott2', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: u_tenant was not successful. See logs for details.';

  -- ----------------------------------
  -- Deactivate (hide) a Tenant
  -- ----------------------------------
  call pareto.deact_tenant(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: deact_tenant was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Reactivate a Tenant
  -- ----------------------------------
  call pareto.react_tenant(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: react_tenant was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Delete
  -- ----------------------------------
  call pareto.d_alt_tenant(c_name, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_alt_tenant was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Delete (by id)
  -- ----------------------------------
  call pareto.i_tenant(c_name, c_description, c_copyright, 'Scott1', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_tenant was not successful. See logs for details.';

  call pareto.d_pri_tenant(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_alt_tenant was not successful. See logs for details.';

end;
$$;

call pareto.t_tenant();
drop procedure if exists pareto.t_tenant;