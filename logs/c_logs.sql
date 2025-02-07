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

create table pareto.logs (  
  id                    uuid         not null default gen_random_uuid(),
  created_at            timestamptz  not null default current_timestamp,
  level                 varchar(10)  not null check (level in ('DEBUG','INFO','WARNING','ERROR','CRITICAL')),
  message               text         not null,
  service_name          varchar(255) not null,
  created_by            varchar(50),
  metadata JSONB default '{}'::JSONB
);

alter table pareto.logs
  add primary key (id);

create index logs_created_at   on pareto.logs (created_at desc);
create index logs_level        on pareto.logs (level);
create index logs_service_name on pareto.logs (service_name);