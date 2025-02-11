-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_ref_tables;
create procedure pareto.t_ref_tables()
language plpgsql
as $$
declare
 
  c_tenant_name constant varchar := 'system';
  c_test_name   constant varchar := 't_ref_tables';
  c_name        constant varchar := 't_ref_tables';
  c_description constant varchar := 't_description';
  c_value       constant varchar := 't_value';
  c_sort_seq    constant int     := 1;
  c_username    constant varchar := 't_username';
  
  v_id_tenant         uuid;
  v_id_ref_table_type uuid;

  v_id                uuid;   
  v_response          pareto.response;
  
begin

  raise notice 'Test ref_tables Persist Beginning';

  -- ----------------------------------
  -- Get the 'system' tenant id
  -- ----------------------------------
  select id into v_id_tenant
    from pareto.tenant 
   where name = c_tenant_name;

  -- ----------------------------------
  -- Create the Reference Table Type
  -- ----------------------------------
  call pareto.i_ref_table_type(c_name, c_description, true, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_ref_table_type was not successful. See logs for details.';

  v_id_ref_table_type := v_response.id;

  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    c_name,  
    c_description, 
    c_value, 
    c_sort_seq, 
    'scott', 
    v_response);
  
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_ref_tables was not successful. See logs for details.';
 
  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_ref_tables(
    v_response.id, 
    c_name, 
    c_description, 
    c_value, 
    c_sort_seq, 
    'scott', 
    v_response);
  
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: u_ref_tables was not successful. See logs for details.';

  -- ----------------------------------
  -- Deactivate (hide) a ref_tables
  -- ----------------------------------
  call pareto.deact_ref_tables(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: deact_ref_tables was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Reactivate a ref_tables
  -- ----------------------------------
  call pareto.react_ref_tables(v_response.id, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: react_ref_tables was not successful. See logs for details.';
  
  -- ----------------------------------
  -- Delete
  -- ----------------------------------
  call pareto.d_ref_tables(v_response.id, c_username, v_response);
    
  select id into v_id
    from pareto.ref_tables
   where id = v_response.id;

  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_tables was not successful. See logs for details.';

  -- ----------------------------------
  -- Clean
  -- ----------------------------------
  call pareto.d_ref_table_type(v_id_ref_table_type, c_username, v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: d_tables was not successful. See logs for details.';

  rollback;
  raise notice 'Test ref_tables Persist Completed';

end;
$$;

call pareto.t_ref_tables();
drop procedure if exists pareto.t_ref_tables;