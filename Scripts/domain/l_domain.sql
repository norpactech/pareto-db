-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.l_domain;
create procedure pareto.l_domain()
language plpgsql
as $$
declare 

  c_system_schema    constant varchar := 'system';
  c_reference_schema constant varchar := 'reference';
  
  v_id_schema uuid;
  v_response  pareto.response;

begin

  -- ----------------------------------
  -- System Schema
  -- ----------------------------------
  
  select id into v_id_schema
    from pareto.schema
   where name = c_system_schema;
  assert v_id_schema is not null;
    
  call pareto.i_domain(v_id_schema, 'commons', 'Commons Domain for Users, Tables, and Tenants', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_domain(v_id_schema, 'schema', 'Schema Domain for Schema, Domains and Objects', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  -- ----------------------------------
  -- Reference Schema
  -- ----------------------------------
  
  select id into v_id_schema
    from pareto.schema
   where name = c_reference_schema;
  assert v_id_schema is not null;
    
  call pareto.i_domain(v_id_schema, 'customer', 'Customer Domain', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
end;
$$;

call pareto.l_domain();
drop procedure if exists pareto.l_domain;
