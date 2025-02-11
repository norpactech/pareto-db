-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.i_object_attribute;
drop procedure if exists pareto.u_object_attribute;
drop procedure if exists pareto.d_object_attribute;
drop procedure if exists pareto.deact_object_attribute;
drop procedure if exists pareto.react_object_attribute;
drop procedure if exists pareto.common_attributes;

create procedure pareto.i_object_attribute(
  in in_id_domain_object uuid,
  in in_id_rt_data_type  uuid,
  in in_name             varchar,
  in in_description      text,
  in in_length           int,
  in in_precision        int,
  in in_is_nullable      boolean,
  in in_default_value    varchar,
  in in_seq              int,
  in in_created_by       varchar,
  out response           pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.i_object_attribute';
  v_id         uuid;
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id_domain_object', in_id_domain_object,
    'id_rt_data_type' , in_id_rt_data_type,
    'name'            , in_name,
    'description'     , in_description,
    'length'          , in_length,
    'precision'       , in_precision,
    'is_nullable'     , in_is_nullable,
    'default_value'   , in_default_value,
    'seq'             , in_seq,
    'created_by'      , in_created_by
  );

  insert into pareto.object_attribute (
    id_domain_object,
    id_rt_data_type,
    name,
    description,
    length,
    precision,
    is_nullable,
    default_value,
    seq,
    created_by,
	  updated_by
  )
  values (
    in_id_domain_object,
    in_id_rt_data_type,
    in_name,
    in_description,
    in_length,
    in_precision,
    in_is_nullable,
    in_default_value,
    in_seq,
    in_created_by,
	  in_created_by
  )
  returning id, updated_at into v_id, v_updated_at;

  response.success := true;
  response.id := v_id;
  response.updated := v_updated_at;
  response.message := 'Insert Successful';
  
exception
  when unique_violation then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Object Attribute Already Exists';
    call pareto.i_logs('ERROR', response.message, c_service_name, in_created_by, v_metadata);
	
  when others then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Exception: ' || sqlerrm;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_created_by, v_metadata);
	
end;
$$;

-- ----------------------------------------------------------------------------
-- Update
-- ----------------------------------------------------------------------------

create procedure pareto.u_object_attribute(
  in in_id              uuid,
  in in_id_rt_data_type uuid,
  in in_name            varchar,
  in in_description     text,
  in in_length          int,
  in in_precision       int,
  in in_is_nullable     boolean,
  in in_default_value   varchar,
  in in_seq             int,
  in in_updated_by      varchar,
  out response          pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.u_object_attribute';
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id'             , in_id,
    'id_rt_data_type', in_id_rt_data_type,
    'name'           , in_name,
    'length'         , in_length,
    'precision'      , in_precision,
    'is_nullable'    , in_is_nullable,
    'default_value'  , in_default_value,
    'seq'            , in_seq,
    'updated_by'     , in_updated_by
  );

  update pareto.object_attribute set 
    id_rt_data_type = in_id_rt_data_type,
    name            = in_name,
    description     = in_description,
    length          = in_length,
    precision       = in_precision,
    is_nullable     = in_is_nullable,
    default_value   = in_default_value,
    seq             = in_seq,
	  updated_by      = in_updated_by
  where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Object Attribute not Found for Primary Key: ' || coalesce(in_id::text, 'NULL');
    call pareto.i_logs('ERROR', response.message, c_service_name, in_updated_by, v_metadata);
  else
    response.success := true;
    response.id := in_id;
    response.updated := v_updated_at;
    response.message := 'Update Successful';
  end if;

exception
  when others then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Exception: ' || sqlerrm;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_updated_by, v_metadata);
	
end;
$$;

-- ----------------------------------------------------------------------------
-- Delete
-- ----------------------------------------------------------------------------

create procedure pareto.d_object_attribute(
  in in_id          uuid,
  in in_deleted_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.d_object_attribute';
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  delete from pareto.object_attribute 
   where id = in_id;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Object Attribute does not exist for Primary Key: ' || coalesce(in_id::text, 'NULL');
    call pareto.i_logs('ERROR', response.message, c_service_name, in_deleted_by, v_metadata);
  else
    response.success := true;
    response.id := null;
    response.updated := null;
    response.message := 'Delete Successful';
    call pareto.i_logs('INFO', response.message, c_service_name, in_deleted_by, v_metadata);
  end if;

exception
  when others then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Exception: ' || sqlerrm;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_deleted_by, v_metadata);
  
end;
$$;

-- ----------------------------------------------------------------------------
-- Set to Deactivate Status (hide)
-- ----------------------------------------------------------------------------

create procedure pareto.deact_object_attribute(
  in in_id          uuid,
  in in_deact_by    varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.deact_object_attribute';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.object_attribute set is_active = false
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Object Attribute does not exist for id: ' || coalesce(in_id::text, 'NULL');
    call pareto.i_logs('ERROR', response.message, c_service_name, in_deact_by, v_metadata);
  else
    response.success := true;
    response.id := in_id;
    response.updated := v_updated_at;
    response.message := 'Deactivate Successful';
  end if;

exception
  when others then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Exception: ' || sqlerrm;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_deact_by, v_metadata);
  
end;
$$;

-- ----------------------------------------------------------------------------
-- Set to Active Status
-- ----------------------------------------------------------------------------

create procedure pareto.react_object_attribute(
  in in_id          uuid,
  in in_react_by    varchar,  
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.react_object_attribute';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.object_attribute set is_active = true
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Object Attribute does not exist for id: ' || coalesce(in_id::text, 'NULL');
    call pareto.i_logs('ERROR', response.message, c_service_name, in_react_by, v_metadata);
  else
    response.success := true;
    response.id := in_id;
    response.updated := v_updated_at;
    response.message := 'Reactivate Successful';
  end if;

exception
  when others then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Exception: ' || sqlerrm;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_react_by, v_metadata);
  
end;
$$;

-- ----------------------------------------------------------------------------
-- Common Attributes
-- ----------------------------------------------------------------------------

create procedure pareto.common_attributes(
  in in_tenant_name      varchar,
  in in_id_domain_object uuid,
  in in_username         varchar,
  in in_seq              int
)
language plpgsql
as $$
declare
 
  c_table_type_name constant varchar := 'datatype';
  
  v_id_rt_data_type uuid;
  v_seq             int := 1;
  v_response pareto.response;
  
begin

  raise notice 'Beginning Common Attributes Load';
  v_seq := in_seq;
  
  select pareto.g_id_ref_tables_alt_keys(in_tenant_name, c_table_type_name, 'uuid') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type.';
  call pareto.i_object_attribute(
    in_id_domain_object,
    v_id_rt_data_type,
    'id',                -- name
    'Primary Key',       -- description
    null,                -- length
    null,                -- precision
    false,               -- is_nullable
    'generated uuid',    -- default_value    
    1,
    in_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';

  v_seq := v_seq + 1;
  select pareto.g_id_ref_tables_alt_keys(in_tenant_name, c_table_type_name, 'timestamptz') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type <timestamptz>.';
  call pareto.i_object_attribute(
    in_id_domain_object,
    v_id_rt_data_type,
    'created_at',        -- name
    'Created Timestamp', -- description
    null,                -- length
    null,                -- precision
    false,               -- is_nullable
    'timestamp',         -- default_value    
    v_seq,               -- sequence
    in_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';
  
  v_seq := v_seq + 1;
  select pareto.g_id_ref_tables_alt_keys(in_tenant_name, c_table_type_name, 'varchar') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type <varchar>.';
  call pareto.i_object_attribute(
    in_id_domain_object,
    v_id_rt_data_type,
    'created_by',        -- name
    'Created By tenant',   -- description
    50,                  -- length
    null,                -- precision
    false,               -- is_nullable
    null,                -- default_value    
    v_seq,               -- sequence
    in_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';
  
  v_seq := v_seq + 1;
  select pareto.g_id_ref_tables_alt_keys(in_tenant_name, c_table_type_name, 'timestamptz') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type <timestamptz>.';
  call pareto.i_object_attribute(
    in_id_domain_object,
    v_id_rt_data_type,
    'updated_at',        -- name
    'Updated Timestamp', -- description
    null,                -- length
    null,                -- precision
    false,               -- is_nullable
    'timestamp',         -- default_value    
    v_seq,               -- sequence
    in_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';
  
  v_seq := v_seq + 1;
  select pareto.g_id_ref_tables_alt_keys(in_tenant_name, c_table_type_name, 'varchar') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type <varchar>.';
  call pareto.i_object_attribute(
    in_id_domain_object,
    v_id_rt_data_type,
    'updated_by',        -- name
    'Updated By tenant',   -- description
    50,                  -- length
    null,                -- precision
    false,               -- is_nullable
    null,                -- default_value    
    v_seq,               -- sequence
    in_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';

  v_seq := v_seq + 1;
  select pareto.g_id_ref_tables_alt_keys(in_tenant_name, c_table_type_name, 'boolean') into v_id_rt_data_type;
  assert v_id_rt_data_type is not null, 'Test failed: g_id_ref_tables_alt_keys failed to find data type <boolean>.';
  call pareto.i_object_attribute(
    in_id_domain_object,
    v_id_rt_data_type,
    'is_active',         -- name
    'Soft Delete',       -- description
    null,                -- length
    null,                -- precision
    false,               -- is_nullable
    'true',              -- default_value    
    v_seq,               -- sequence
    in_username,
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true, 'Test failed: i_object_attribute was not successful. See logs for details.';  
end;
$$;