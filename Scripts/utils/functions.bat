@echo off
rem ----------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC.
rem 
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
echo Beginning Created Functions Successfully

cd ..\ddl\validation
call create_validation.bat || goto exception
cd ..\..\utils

cd ..\ddl\insert
call create_insert.bat || goto exception
cd ..\..\utils

cd ..\ddl\update
call create_update.bat || goto exception
cd ..\..\utils

cd ..\ddl\delete
call create_delete.bat || goto exception
cd ..\..\utils

cd ..\ddl\active
call create_active.bat || goto exception
cd ..\..\utils

echo Completed Created Functions Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Create Functions Failed!
exit /b 1
