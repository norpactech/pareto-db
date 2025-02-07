@echo off
-- ============================================================================
-- Copyright (C) 2022-2025 Northern Pacific Technologies, LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License"); you may not 
-- use this file except in compliance with the License. You may obtain a copy 
-- of the License at http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software 
-- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
-- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
-- License for the specific language governing permissions and limitations 
-- under the License.
-- ============================================================================

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
