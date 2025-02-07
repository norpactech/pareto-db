-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.ref_table_type (
  
  id uuid                                     default gen_random_uuid(),
  name                  varchar(50) not null,
  description           text,
  is_global             boolean     not null,
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
);

alter table pareto.ref_table_type
  add primary key (id);

create unique index ref_table_type_alt_key on pareto.tenant(lower(name));

create trigger ref_table_type_update_at
  before update on pareto.ref_table_type
    for each row
      execute function pareto.update_at();