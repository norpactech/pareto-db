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

  v_response pareto.response;

begin

  call pareto.i_tenant('system', 'System Tenant for Global Actions', 'Norther Pacific Technologies', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;

  call pareto.i_tenant('reference', 'Pareto Reference/Example Tenant', 'Norther Pacific Technologies', 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  assert v_response.success = true;
  
end;
$$;

call pareto.l_tenant();
drop procedure if exists pareto.l_tenant;
