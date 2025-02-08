@echo off
rem ----------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC.
rem Licensed under the MIT License.
rem See LICENSE file in the project root for full license information.
rem ----------------------------------------------------------------------------

rem Recreate the norpac schema
psql -d norpac -h localhost -p 5432 -f ".\rebuild.sql"

rem Create Tables 

psql -d norpac -h localhost -p 5432 -f "..\logs\c_logs.sql"
psql -d norpac -h localhost -p 5432 -f "..\tenant\c_tenant.sql"
psql -d norpac -h localhost -p 5432 -f "..\ref_table_type\c_ref_table_type.sql"
psql -d norpac -h localhost -p 5432 -f "..\ref_tables\c_ref_tables.sql"

rem Create Stored Procedures 

psql -d norpac -h localhost -p 5432 -f "..\logs\s_logs.sql"
psql -d norpac -h localhost -p 5432 -f "..\tenant\s_tenant.sql"
