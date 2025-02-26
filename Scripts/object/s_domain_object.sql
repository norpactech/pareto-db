-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.i_domain_object;
drop procedure if exists pareto.u_domain_object;
drop procedure if exists pareto.d_domain_object;
drop procedure if exists pareto.deact_domain_object;
drop procedure if exists pareto.react_domain_object;

create procedure pareto.i_domain_object(
  in in_id_domain   uuid,
  in in_name        varchar,
  in in_description text,
  in in_has_audit   boolean,
  in in_created_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.i_domain_object';
  v_id uuid;
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id_domain'  , in_id_domain,
    'name'       , in_name,
    'description', in_description
  );

  insert into pareto.domain_object (
    id_domain,
    name,
    description,
    has_audit,
    created_by,
	  updated_by
  )
  values (
    in_id_domain,
    in_name,
    in_description,
    in_has_audit,
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
    response.message := 'Error: Domain Object Already Exists';
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

create procedure pareto.u_domain_object(
  in in_id          uuid,
  in in_name        varchar,
  in in_description text,
  in in_has_audit   boolean,
  in in_updated_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.u_domain_object';
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id'         , in_id,
    'name'       , in_name,
    'description', in_description,
    'has_audit'  , in_has_audit
  );

  update pareto.domain_object set 
    name        = in_name,
    description = in_description,
    has_audit   = in_has_audit,
    updated_by  = in_updated_by
  where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Domain Object not Found for Primary Key: ' || coalesce(in_id::text, 'NULL');
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

create procedure pareto.d_domain_object(
  in in_id          uuid,
  in in_deleted_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.d_domain_object';
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  delete from pareto.domain_object 
   where id = in_id;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Domain Object does not exist for Primary Key: ' || coalesce(in_id::text, 'NULL');
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

create procedure pareto.deact_domain_object(
  in in_id          uuid,
  in in_deact_by    varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.deact_domain_object';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.domain_object set is_active = false
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Domain Object does not exist for id: ' || coalesce(in_id::text, 'NULL');
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

create procedure pareto.react_domain_object(
  in in_id          uuid,
  in in_react_by    varchar,  
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.react_domain_object';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.domain_object set is_active = true
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Domain Object does not exist for id: ' || coalesce(in_id::text, 'NULL');
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