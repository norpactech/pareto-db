-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.i_ref_tables;
drop procedure if exists pareto.u_ref_tables;
drop procedure if exists pareto.d_pri_ref_tables;
drop procedure if exists pareto.d_alt_ref_tables;
drop procedure if exists pareto.deact_ref_tables;
drop procedure if exists pareto.react_ref_tables;

create procedure pareto.i_ref_tables(
  in in_name        varchar,
  in in_description text,
  in in_copyright   varchar,
  
  id_tenant             uuid        not null,
  id_ref_table_type     uuid        not null,
  name                  varchar(50) not null,
  value                 text        not null,
  sort_seq              int         not null  default 0,
  description           text,
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
  
  
  
  
  
  
  
  
  in in_created_by  varchar,
  
  
  
  
  
  
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.i_ref_tables';
  v_id uuid;
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'name'       , in_name,
    'description', in_description,
    'copyright'  , in_copyright
  );

  insert into pareto.ref_tables (
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
    response.message := 'Error: ref_tables already exists.';
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

create procedure pareto.u_ref_tables(
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
 
  c_service_name constant varchar := 'pareto.u_ref_tables';
  v_updated_at timestamp;
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'name'       , in_name,
    'description', in_description,
    'copyright'  , in_copyright
  );

  update pareto.ref_tables set 
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
    response.message := 'Error: ref_tables does not exist for primary key: ' || in_uuid;
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
-- Delete by Primary Key
-- ----------------------------------------------------------------------------

create procedure pareto.d_pri_ref_tables(
  in in_id          uuid,
  in in_deleted_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.d_pri_ref_tables';
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  delete from pareto.ref_tables 
   where id = in_id;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: ref_tables does not exist for Primary Key: ' || in_id;
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
-- Delete by Alternate Key
-- ----------------------------------------------------------------------------

create procedure pareto.d_alt_ref_tables(
  in in_name        varchar,
  in in_deleted_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.d_alt_ref_tables';
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'name', in_name
  );

  delete from pareto.ref_tables 
   where name = in_name;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: ref_tables does not exist for Alternate Key: ' || in_name;
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

create procedure pareto.deact_ref_tables(
  in in_id          uuid,
  in in_deact_by    varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.deact_ref_tables';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.ref_tables set is_active = false
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: ref_tables does not exist for id: ' || in_id;
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

create procedure pareto.react_ref_tables(
  in in_id          uuid,
  in in_react_by    varchar,  
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.react_ref_tables';
  v_metadata   jsonb;
  v_updated_at timestamp;

begin

  v_metadata := jsonb_build_object(
    'id', in_id
  );

  update pareto.ref_tables set is_active = true
   where id = in_id
  returning updated_at into v_updated_at;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: ref_tables does not exist for id: ' || in_id;
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