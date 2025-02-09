-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.l_tenant;
create procedure pareto.l_tenant()
language plpgsql
as $$
declare 

  c_tenant_system constant varchar := 'system';
  c_tenant_norpac constant varchar := 'norpac';
  
  v_id_tenant uuid;
  v_response  pareto.response;

begin

  call pareto.i_tenant(c_tenant_system, 'System Tenant for Global Actions', 'Northern Pacific Technologies', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;

  call pareto.i_tenant(c_tenant_norpac, 'NorPac Tenant for the Router App', 'Northern Pacific Technologies', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
end;
$$;

call pareto.l_tenant();
drop procedure if exists pareto.l_tenant;
