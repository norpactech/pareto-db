@echo off
rem ----------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC.
rem Licensed under the MIT License.
rem See LICENSE file in the project root for full license information.
rem ----------------------------------------------------------------------------

rem Load Tables 

psql -d norpac -h localhost -p 5432 -f "..\tenant\l_tenant.sql"
