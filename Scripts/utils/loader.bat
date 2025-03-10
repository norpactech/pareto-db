@echo off
rem ----------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC.
rem Licensed under the MIT License.
rem See LICENSE file in the project root for full license information.
rem ----------------------------------------------------------------------------

rem Load Tables 

if not defined PGHOST (
  set PGHOST=localhost
)

rem Commons Domain
rem goto start

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\l_user.sql"   || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\l_tenant.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\l_schema.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\l_domain.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\domain_objects\l_user.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\domain_objects\l_tenant.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\domain_objects\l_ref_table_type.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\domain_objects\l_domain_object.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\domain_objects\l_object_attribute.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\etl\domain_objects\l_logs.sql" || goto exception

rem Load Table Values
rem psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\ref_tables\l_datatypes.sql" || goto exception

rem Schema Domain
rem psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\schema\l_schema.sql" || goto exception
rem psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain\l_domain.sql" || goto exception

rem psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain_object\l_commons.sql" || goto exception
rem psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain_object\l_schema.sql" || goto exception

rem ----------------------------------------------------------------------------
rem Create the Object/Table Structures for Pareto
rem 
rem Note: Review the REST API loader for the Router Application
rem ----------------------------------------------------------------------------
rem psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\object_attribute\l_user.sql" || goto exception
rem psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\object_attribute\l_tenant.sql" || goto exception
rem psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\object_attribute\l_ref_table_type.sql" || goto exception

:start


echo Loader Completed Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Loader Failed!
exit /b 1