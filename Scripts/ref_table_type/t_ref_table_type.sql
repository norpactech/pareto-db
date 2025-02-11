-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_ref_table_type;
create procedure pareto.t_ref_table_type()
language plpgsql
as $$
declare
 
  c_test_name   constant varchar := 't_ref_table_type';
  c_name        constant varchar := 't_ref_table_type';
  c_description constant varchar := 't_description';
  c_username    constant varchar := 't_username';
  
  v_id          uuid;        
  v_is_global   boolean := true;
  v_response    pareto.response;
  
begin

  raise notice 'Test ref_table_type Persist Beginning';

  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_ref_table_type(c_name, c_description, v_is_global, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_ref_table_type was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_ref_table_type(v_response.id, c_name, c_description, v_is_global, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: u_ref_table_type was not successful. See logs for details.';

  -- ----------------------------------
  -- Deactivate (hide) a ref_table_type
  -- ----------------------------------
  call pareto.deact_ref_table_type(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: deact_ref_table_type was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Reactivate a ref_table_type
  -- ----------------------------------
  call pareto.react_ref_table_type(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: react_ref_table_type was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Delete
  -- ----------------------------------
  call pareto.d_ref_table_type(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_alt_ref_table_type was not successful. See logs for details.';

  rollback;
  raise notice 'Test ref_table_type Persist Completed';

end;
$$;

call pareto.t_ref_table_type();
drop procedure if exists pareto.t_ref_table_type;