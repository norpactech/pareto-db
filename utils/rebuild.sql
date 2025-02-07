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

-- ----------------------------------------------------------------------------
-- Drop all dependent objects and recreate the schema
-- ----------------------------------------------------------------------------

drop schema if exists pareto cascade;
create schema pareto authorization norpac;

-- ----------------------------------------------------------------------------
-- Trigger function(s)
-- ----------------------------------------------------------------------------

create function pareto.update_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ----------------------------------------------------------------------------
-- Type(s)
-- ----------------------------------------------------------------------------

create type pareto.response AS (
  success boolean,
  id uuid,
  updated timestamp,
  message text
);
