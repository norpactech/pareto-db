-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.l_customer;
create procedure pareto.l_customer()
language plpgsql
as $$
declare 

  c_tenant_name constant varchar := 'norpac';
  c_schema_name constant varchar := 'router';
  c_domain_name constant varchar := 'customer';
  
  v_id_domain uuid;
  v_id_object uuid;
  v_response  pareto.response;

begin

  raise notice 'Beginning System Commons Object Load';

  -- ----------------------------------
  -- v_id_domain
  -- ----------------------------------
  select pareto.g_id_domain_alt_keys(c_tenant_name, c_schema_name, c_domain_name) into v_id_domain;
  assert v_id_domain is not null, 'Test failed: g_id_domain_alt_keys failed to find the domain.';
  
  -- ----------------------------------
  -- Build System Commons Objects
  -- ----------------------------------
  call pareto.i_domain_object(v_id_domain, 'customer', 'Customer Object', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
  raise notice 'Completed System Commons Object Load';

end;
$$;

call pareto.l_customer();
drop procedure if exists pareto.l_customer;
