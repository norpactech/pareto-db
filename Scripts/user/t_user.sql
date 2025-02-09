-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_user;
create procedure pareto.t_user()
language plpgsql
as $$
declare
 
  c_test_name   constant varchar := 't_user';
  c_username    constant varchar := 't_username';
  c_email       constant varchar := 't_email';
  c_full_name   constant varchar := 't_full_name';

  v_id          uuid;        
  v_response    pareto.response;
  
begin

  raise notice 'Test user Persist Beginning';

  -- ----------------------------------
  -- Clean if necessary
  -- ----------------------------------
  select id into v_id 
    from pareto.user 
   where username = c_username;
   
  if (v_id is not null) then
    raise notice 'WARNING: user value "%" existed from a previous test. Deleting...', c_username;
    call pareto.d_user(v_id, c_username, v_response);
    raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  end if;

  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_user(c_username, c_email, c_full_name, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_user was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_user(v_response.id, c_username, c_email, c_full_name, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: u_user was not successful. See logs for details.';

  -- ----------------------------------
  -- Deactivate (hide) a user
  -- ----------------------------------
  call pareto.deact_user(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: deact_user was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Reactivate a user
  -- ----------------------------------
  call pareto.react_user(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: react_user was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Delete
  -- ----------------------------------
  call pareto.d_user(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_alt_user was not successful. See logs for details.';

  raise notice 'Test user Persist Completed';

end;
$$;

call pareto.t_user();
drop procedure if exists pareto.t_user;