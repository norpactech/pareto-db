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

create procedure pareto.i_logs(
  in in_level         varchar,
  in in_message       text,
  in in_service_name  varchar,
  in in_created_by    varchar,
  in in_metadata      jsonb
)
language plpgsql
as $$
declare
begin

  insert into pareto.logs (
    level,
    message,
    service_name,
    created_by,
	metadata
  )
  values (
    in_level,
    in_message,
    in_service_name,
    in_created_by,
	in_metadata
  );

end;
$$;



