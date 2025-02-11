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
 
  c_tenant_name    constant varchar := 'system';
  c_schema_name    constant varchar := 'pareto';
  c_domain_name    constant varchar := 'commons';
  c_data_type      constant varchar := 'numeric';

  c_object_name    constant varchar := 't_object';
  c_attribute_name constant varchar := 't_attribute';
  c_description    constant varchar := 't_description';
  c_length         constant int     := 10;
  c_precision      constant int     := 2;  
  c_is_nullable    constant boolean := true;
  c_default_value  constant varchar := 't_default';
  c_seq            constant int     := 1;
  c_username       constant varchar := 't_username';
  
  v_id_domain        uuid;
  v_id_domain_object uuid;
  v_id_rt_data_type  uuid;
  v_response         pareto.response;
  
begin

  raise notice 'Beginning object_attribute Test';

  -- ----------------------------------
  -- v_id_domain
  -- ----------------------------------
  select pareto.g_id_domain_alt_keys(c_tenant_name, c_schema_name, c_domain_name) into v_id_domain;
  assert v_id_domain is not null, 'Test failed: g_id_domain_alt_keys failed to find the domain.';

  -- ----------------------------------
  -- Create a Domain Object
  -- ----------------------------------
  call pareto.i_domain_object(v_id_domain, c_object_name, c_description, true, 'scott1', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_domain_object was not successful. See logs for details.';
  v_id_domain_object = v_response.id;

  -- ----------------------------------
  -- Get a Test Data Type
  -- ----------------------------------
  select pareto.g_id_ref_tables_alt_keys('system', 'datatype', 'numeric') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find the data type.';
  
  -- ----------------------------------
  -- Insert
  -- ----------------------------------
  call pareto.i_object_attribute(
    v_id_domain_object,
    v_id_rt_data_type,
    c_attribute_name,
    c_description,
    c_length ,
    c_precision,
    c_is_nullable,
    c_default_value,
    c_seq,
    c_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';

  -- ----------------------------------
  -- Update
  -- ----------------------------------
  call pareto.u_object_attribute(
    v_response.id,
    v_id_rt_data_type,
    c_attribute_name,
    c_description,
    c_length,
    c_precision,
    c_is_nullable,
    c_default_value,
    c_seq,
    c_username,
    v_response);
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
 
  rollback;
  raise notice 'Completed object_attribute Test';

end;
$$;

call pareto.t_object_attribute();
drop procedure if exists pareto.t_object_attribute;