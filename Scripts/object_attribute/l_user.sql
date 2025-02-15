-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.l_user;
create procedure pareto.l_user()
language plpgsql
as $$
declare 

  c_tenant_name     constant varchar := 'system';
  c_schema_name     constant varchar := 'pareto';
  c_domain_name     constant varchar := 'commons';
  c_object_name     constant varchar := 'user';
  c_table_type_name constant varchar := 'datatype';
  c_username        constant varchar := 'loader';
  
  v_seq              int := 1;

  v_id_domain_object uuid;
  v_id_rt_data_type  uuid;
  v_response         pareto.response;

begin

  raise notice 'Beginning User Attributes Load';

  -- ----------------------------------
  -- v_id_domain_object
  -- ----------------------------------
  select pareto.g_id_domain_object_alt_keys(c_tenant_name, c_schema_name, c_domain_name, c_object_name) into v_id_domain_object;
  assert v_id_domain_object is not null, 'Load failed: g_id_domain_object_alt_keys failed to find the domain object.';
  
  v_seq := v_seq + 1;
  select pareto.g_id_ref_tables_alt_keys(c_tenant_name, c_table_type_name, 'varchar') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type <varchar>.';
  call pareto.i_object_attribute(
    v_id_domain_object,
    v_id_rt_data_type,
    'username',          -- name
    'Username',          -- description
    50,                  -- length
    null,                -- precision
    false,               -- is_nullable
    null,                -- default_value
    v_seq,               -- sequence
    c_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';

  v_seq := v_seq + 1;
  select pareto.g_id_ref_tables_alt_keys(c_tenant_name, c_table_type_name, 'varchar') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type <varchar>.';
  call pareto.i_object_attribute(
    v_id_domain_object,
    v_id_rt_data_type,
    'email',             -- name
    'Email Address',     -- description
    100,                 -- length
    null,                -- precision
    false,               -- is_nullable
    null,                -- default_value
    v_seq,               -- sequence
    c_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';
  
  v_seq := v_seq + 1;
  select pareto.g_id_ref_tables_alt_keys(c_tenant_name, c_table_type_name, 'varchar') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type <varchar>.';
  call pareto.i_object_attribute(
    v_id_domain_object,
    v_id_rt_data_type,
    'full_name',         -- name
    'User Full Name',    -- description
    50,                  -- length
    null,                -- precision
    false,               -- is_nullable
    null,                -- default_value
    v_seq,               -- sequence
    c_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';
  
  v_seq := v_seq + 1;
  call pareto.common_attributes(c_tenant_name, v_id_domain_object, c_username, v_seq);

  raise notice 'Completed User Attributes Load';

end;
$$;

call pareto.l_user();
drop procedure if exists pareto.l_user;
