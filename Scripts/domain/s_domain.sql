-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.i_domain;
drop procedure if exists pareto.u_domain;
drop procedure if exists pareto.d_domain;
drop procedure if exists pareto.deact_domain;
drop procedure if exists pareto.react_domain;

create procedure pareto.i_domain(
  in in_id_schema   uuid,
  in in_name        varchar,
  in in_description text,
  in in_created_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.i_domain';
  v_id uuid;
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id_schema'  , in_id_schema,
    'name'       , in_name,
    'description', in_description
  );

  insert into pareto.domain (
    id_schema,
    name,
    description,
    created_by,
	updated_by
  )
  values (
    in_id_schema,
    in_name,
    in_description,
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
    response.message := 'Error: Domain Already Exists';
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

create procedure pareto.u_domain(
  in in_id          uuid,
  in in_name        varchar,
  in in_description text,
  in in_updated_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.u_domain';
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id'         , in_id,
    'name'       , in_name,
    'description', in_description
  );

  update pareto.domain set 
    name        = in_name,
    description = in_description,
	  updated_by  = in_updated_by
  where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Domain not Found for Primary Key: ' || in_uuid;
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

create procedure pareto.d_domain(
  in in_id          uuid,
  in in_deleted_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.d_domain';
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  delete from pareto.domain 
   where id = in_id;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Domain does not exist for Primary Key: ' || coalesce(in_id::text, 'NULL');
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

create procedure pareto.deact_domain(
  in in_id          uuid,
  in in_deact_by    varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.deact_domain';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.domain set is_active = false
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Domain does not exist for id: ' || coalesce(in_id::text, 'NULL');
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

create procedure pareto.react_domain(
  in in_id          uuid,
  in in_react_by    varchar,  
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.react_domain';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.domain set is_active = true
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Domain does not exist for id: ' || coalesce(in_id::text, 'NULL');
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