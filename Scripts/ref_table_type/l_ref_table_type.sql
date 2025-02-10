-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.l_ref_table_type;
create procedure pareto.l_ref_table_type()
language plpgsql
as $$
declare 

  v_response pareto.response;

begin
  
  call pareto.i_ref_table_type('datatype', 'Data Types', true, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;

end;
$$;

call pareto.l_ref_table_type();
drop procedure if exists pareto.l_ref_table_type;
