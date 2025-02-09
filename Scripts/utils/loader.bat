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

psql -d norpac -h %PGHOST% -p 5432 -f "..\user\l_user.sql" || goto exception
psql -d norpac -h %PGHOST% -p 5432 -f "..\tenant\l_tenant.sql"  || goto exception

rem Schema Domain

psql -d norpac -h %PGHOST% -p 5432 -f "..\schema\l_schema.sql"  || goto exception

echo Loader Completed Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Loader Failed!
exit /b 1