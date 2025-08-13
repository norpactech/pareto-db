@echo off
rem ----------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
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

echo Beginning Create Tables

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "context.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "user.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "tenant.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "plugin.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "tenant_user.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "generic_data_type.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "ref_table_type.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "schema.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "context_data_type.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "ref_tables.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "data_object.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "project.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "generic_data_type_attribute.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "validation.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "data_index.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "project_component.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "generic_property_type.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "project_component_property.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "context_property_type.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "property.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "cardinality.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "data_index_property.sql" || goto exception  

echo Completed Create Tables Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Tests Failed! Stopping Execution
rem ---------------------------------------------------------------------------
:exception
echo Create Tables Failed!
exit /b 1
