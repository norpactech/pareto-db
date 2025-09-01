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

SET PGHOST=localhost

echo Beginning Multi-Tenant Test

echo Step 1: Setting up RLS policies as table owner (norpac)
SET PGUSER=norpac
SET PGPASSWORD=password
psql -d norpac -h %PGHOST% -p %PGPORT% -f ".\setup-rls.sql" || goto exception

echo Step 2: Testing RLS as web_update user
SET PGUSER=web_update
SET PGPASSWORD=password
psql -d norpac -h %PGHOST% -p %PGPORT% -f ".\test-multi-tenancy.sql" || goto exception

echo Completed Multi-Tenancy Test Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Multi-Tenancy Test Failed!
exit /b 1