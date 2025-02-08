-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.i_tenant;
drop procedure if exists pareto.u_tenant;
drop procedure if exists pareto.d_pri_tenant;
drop procedure if exists pareto.d_alt_tenant;
drop procedure if exists pareto.deact_tenant;
drop procedure if exists pareto.react_tenant;

create procedure pareto.i_tenant(
  in in_name        varchar,
  in in_description text,
  in in_copyright   varchar,
  in in_created_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.i_tenant';
  v_id uuid;
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'name'       , in_name,
    'description', in_description,
    'copyright'  , in_copyright
  );

  insert into pareto.tenant (
    name,
    description,
    copyright,
    created_by,
	updated_by
  )
  values (
    in_name,
    in_description,
    in_copyright,
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
    response.message := 'Error: Tenant Already Exists';
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

create procedure pareto.u_tenant(
  in in_id          uuid,
  in in_name        varchar,
  in in_description text,
  in in_copyright   varchar,
  in in_updated_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.u_tenant';
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id'         , in_id,
    'name'       , in_name,
    'description', in_description,
    'copyright'  , in_copyright
  );

  update pareto.tenant set 
    name = in_name,
    description = in_description,
    copyright = in_copyright,
	updated_by = in_updated_by
  where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Tenant not Found for Primary Key: ' || in_uuid;
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

create procedure pareto.d_tenant(
  in in_id          uuid,
  in in_deleted_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.d_pri_tenant';
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  delete from pareto.tenant 
   where id = in_id;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Tenant does not exist for Primary Key: ' || in_id;
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

create procedure pareto.deact_tenant(
  in in_id          uuid,
  in in_deact_by    varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.deact_tenant';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.tenant set is_active = false
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Tenant does not exist for id: ' || in_id;
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

create procedure pareto.react_tenant(
  in in_id          uuid,
  in in_react_by    varchar,  
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.react_tenant';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.tenant set is_active = true
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Tenant does not exist for id: ' || in_id;
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