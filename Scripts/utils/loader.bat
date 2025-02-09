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
goto start

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\user\l_user.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\tenant\l_tenant.sql" || goto exception

rem Schema Domain

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\schema\l_schema.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain\l_domain.sql" || goto exception

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain_object\l_commons.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain_object\l_schema.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\object_attribute\l_user.sql" || goto exception

rem router reference app
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain_object\l_customer.sql" || goto exception

:start
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\object_attribute\l_user.sql" || goto exception


echo Loader Completed Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Loader Failed!
exit /b 1