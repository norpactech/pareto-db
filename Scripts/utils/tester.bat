@echo off
rem ---------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC.
rem Licensed under the MIT License.
rem See LICENSE file in the project root for full license information.
rem ---------------------------------------------------------------------------

rem Run Tests

psql -d norpac -h localhost -p 5432 -f "..\tenant\t_tenant.sql"
psql -d norpac -h localhost -p 5432 -f "..\ref_table_type\t_ref_table_type.sql"
psql -d norpac -h localhost -p 5432 -f "..\ref_tables\t_ref_tables.sql"
