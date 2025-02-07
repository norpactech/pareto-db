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
create table pareto.ref_tables (
  
  id uuid                                     default gen_random_uuid(),
  id_ref_table_type     uuid        not null,
  name                  varchar(50) not null,
  value                 text        not null,
  sort_seq              int         not null  default 0,
  description           text,
  is_global             boolean     not null,
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
);

alter table pareto.ref_tables
  add primary key (id);

alter table pareto.ref_tables
  add constraint ref_tables_ref_table_type
  foreign key (id_ref_table_type)
  references pareto.ref_table_type(id)
  on update cascade
  on delete cascade;
  
create trigger ref_tables_update_at
  before update on pareto.ref_tables
    for each row
      execute function pareto.update_at();

