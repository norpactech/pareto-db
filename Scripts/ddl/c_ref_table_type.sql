-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.ref_table_type (
  
  id                    pk,
  name                  generic_name not null,
  description           description,
  is_global             boolean      not null,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

alter table pareto.ref_table_type
  add primary key (id);

create unique index ref_table_type_alt_key on pareto.ref_table_type(lower(name));

create trigger update_at
  before update on pareto.ref_table_type
    for each row
      execute function update_at();