@echo off
rem ---------------------------------------------------------------------------
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

echo Beginning Tester
rem  Comment the following line to run all tests 
rem    ... or uncomment and copy specific tests under :tester
rem goto tester

rem Commons Domain

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\user\t_user.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\logs\t_logs.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\tenant\t_tenant.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\ref_table_type\t_ref_table_type.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\ref_tables\t_ref_tables.sql" || goto exception

rem Schema Domain

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\schema\t_schema.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain\t_domain.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\domain_object\t_domain_object.sql" || goto exception
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p 5432 -f "..\object_attribute\t_object_attribute.sql" || goto exception

rem Place Test to be run here
:tester

echo Tester Completed Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Tester Failed!
exit /b 1

