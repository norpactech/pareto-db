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

echo Beginning Validations Tables

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "email.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "fixed_varying.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "full_name.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "name.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "numeric_size.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "package.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "service.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "us_phone.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "us_state.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "us_zip_code.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "username.sql" || goto exception  

echo Completed Create Validations Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Execution Failed - Stopping!
rem ---------------------------------------------------------------------------
:exception
echo Create Validations Failed!
exit /b 1
