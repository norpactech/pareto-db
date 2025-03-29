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

echo Beginning Global Definitions
rem goto start
psql -d norpac -h %PGHOST% -p 5432 -f ".\bootstrap.sql" || goto exception
rem psql -d norpac -h %PGHOST% -p 5432 -f ".\validations.sql" || goto exception

echo Completed Global Definitions

echo Beginning PostgREST Users

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f ".\users.sql" || goto exception

echo Completed PostgREST Users

echo Beginning Create Tables 
rem goto start
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\tables\create.sql" || goto exception


echo Completed Create Tables 
:start

echo Beginning Create Persist Functions
 
echo Completed Create Persist Functions 

echo Create Completed Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Create Failed!
exit /b 1
