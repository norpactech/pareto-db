-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.tenant (
  
  id uuid                                     default gen_random_uuid(),
  name                  varchar(50) not null,
  description           text,
  copyright             varchar(128),
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
);

alter table pareto.tenant
  add primary key (id);

create unique index tenant_alt_key on pareto.tenant(lower(name));

create trigger tenant_update_at
  before update on pareto.tenant
    for each row
      execute function pareto.update_at();
