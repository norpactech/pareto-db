-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.schema (
  
  id uuid                                     default gen_random_uuid(),
  id_tenant             uuid        not null,
  name                  varchar(50) not null,
  description           text,
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
);

alter table pareto.schema
  add primary key (id);

create unique index schema_alt_key 
  on pareto.schema(id_tenant, lower(name));

alter table pareto.schema
  add constraint schema_tenant
  foreign key (id_tenant)
  references pareto.tenant(id)
  on update cascade
  on delete cascade;

create trigger schema_update_at
  before update on pareto.schema
    for each row
      execute function pareto.update_at();
