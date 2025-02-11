-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.t_logs;
create procedure pareto.t_logs()
language plpgsql
as $$
declare
 
  c_test_name    constant varchar := 't_logs';
  c_level        constant varchar := 'DEBUG';
  c_message      constant varchar := 't_message';
  c_service_name constant varchar := 't_service_name';
  c_username    constant varchar := 't_username';
  c_metadata    constant jsonb   := '{"key": "value"}';
  
  v_id          uuid;        
  v_response    pareto.response;
  v_created_at  timestamptz;
  v_count       int;
    
begin

  raise notice 'Test logs Persist Beginning';

  -- ----------------------------------
  -- Clean if necessary
  -- ----------------------------------
  select count(*) into v_count 
    from pareto.logs 
   where service_name = c_service_name;
  
  if v_count > 0 then
    delete from pareto.logs where service_name = c_service_name;
    raise notice 'WARNING: logs existed from a previous test. Deleting...';
  end if;

  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_logs(c_level, c_message, c_service_name, c_username, c_metadata);
  raise notice 'INFO: log Persisted';

  -- ----------------------------------
  -- Clean
  -- ----------------------------------
  delete from pareto.logs where service_name = c_service_name; 
  raise notice 'INFO: log Deleted';
  
  rollback;
  raise notice 'Test logs Persist Completed';

end;
$$;

call pareto.t_logs();
drop procedure if exists pareto.t_logs;