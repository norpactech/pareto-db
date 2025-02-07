-- ============================================================================
-- Copyright (C) 2022-2025 Northern Pacific Technologies, LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License"); you may not 
-- use this file except in compliance with the License. You may obtain a copy 
-- of the License at http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software 
-- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
-- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
-- License for the specific language governing permissions and limitations 
-- under the License.
-- ============================================================================
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
  response.message := 'Insert successful';
  
exception
  when unique_violation then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Tenant already exists.';
    call pareto.i_logs('ERROR', response.message, c_service_name, in_created_by, v_metadata);
	
  when others then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'An unexpected error occurred: ' || sqlerrm;
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
    response.message := 'Error: Tenant does not exist for primary key: ' || in_uuid;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_updated_by, v_metadata);
  else
    response.success := true;
    response.id := in_id;
    response.updated := v_updated_at;
    response.message := 'Update successful';
  end if;

exception
  when others then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'An unexpected error occurred: ' || sqlerrm;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_updated_by, v_metadata);
	
end;
$$;

-- ----------------------------------------------------------------------------
-- Delete by Alt Key
-- ----------------------------------------------------------------------------

create procedure pareto.d_tenant_by_alt_key(
  in in_name        varchar,
  in in_deleted_by  varchar,
  out response      pareto.response
)
language plpgsql
as $$
declare
 
  c_service_name constant varchar := 'pareto.d_tenant';
  v_metadata   jsonb;
  
begin

  v_metadata := jsonb_build_object(
    'name', in_name
  );

  delete from pareto.tenant 
   where name = in_name;

  if not found then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'Error: Tenant does not exist for alternate key: ' || in_name;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_deleted_by, v_metadata);
  else
    response.success := true;
    response.id := null;
    response.updated := null;
    response.message := 'Delete successful';
    call pareto.i_logs('INFO', response.message, c_service_name, in_deleted_by, v_metadata);
  end if;

exception
  when others then
    response.success := false;
    response.id := null;
    response.updated := null;
    response.message := 'An unexpected error occurred: ' || sqlerrm;
    call pareto.i_logs('ERROR', response.message, c_service_name, in_deleted_by, v_metadata);
	
end;
$$;


