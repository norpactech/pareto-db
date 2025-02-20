-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.tenant (
  id                    pk,
  name                  generic_name not null,
  description           description,
  copyright             text,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

alter table pareto.tenant
  add primary key (id);

create unique index tenant_alt_key on pareto.tenant(lower(name));

create trigger update_at
  before update on pareto.tenant
    for each row
      execute function update_at();
