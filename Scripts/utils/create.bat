@echo off
rem ----------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC.
rem Licensed under the MIT License.
rem See LICENSE file in the project root for full license information.
rem
rem To capture all psql output use the following command:
rem  tester.bat > tester.log 2>&1
rem
rem ---------------------------------------------------------------------------

if not defined PGHOST (
  set PGHOST=localhost
)

if not defined PGPORT (
  set PGPORT=5432
)
echo Beginning Global Definitions
rem goto start
psql -d norpac -h %PGHOST% -p %PGPORT% -f ".\bootstrap.sql" || goto exception

echo Beginning PostgREST Users
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f ".\users.sql" || goto exception
echo Completed PostgREST Users

cd ..\ddl\table
call create_table.bat || goto exception
cd ..\..\utils

cd ..\ddl\validation
call create_validation.bat || goto exception
cd ..\..\utils

psql -d norpac -h %PGHOST% -p %PGPORT% -f ".\views.sql" || goto exception

echo Create Completed Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Create Failed!
exit /b 1
