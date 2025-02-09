@echo off
rem ----------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC.
rem Licensed under the MIT License.
rem See LICENSE file in the project root for full license information.
rem ----------------------------------------------------------------------------

call .\create.bat || goto exception
call .\loader.bat || goto exception

exit /b 0

:exception
exit /b 1

