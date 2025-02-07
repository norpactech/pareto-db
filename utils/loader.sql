-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.loader;
create procedure pareto.loader()
language plpgsql
as $$
declare 

  response pareto.response;

begin

  call pareto.i_tenant('norpac-plsql', 'Featherweight Test Postgres System', 'Norther Pacific Technologies', 'Scott', response);
  raise notice '%, %, %, %', response.success, response.id, response.updated, response.message;
  
  call pareto.i_tenant('norpac-mysql', 'Featherweight Test MySQL System', 'Norther Pacific Technologies', 'Scott', response);
  raise notice '%, %, %, %', response.success, response.id, response.updated, response.message;

  

end;
$$;

call pareto.loader();
drop procedure if exists pareto.loader;
