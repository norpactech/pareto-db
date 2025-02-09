-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.domain (
  
  id uuid                                     default gen_random_uuid(),
  id_schema             uuid        not null,
  name                  varchar(50) not null,
  description           text,
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
);

alter table pareto.domain
  add primary key (id);

create unique index domain_alt_key 
  on pareto.domain(id_schema, lower(name));

alter table pareto.domain
  add constraint domain_schema
  foreign key (id_schema)
  references pareto.schema(id)
  on update cascade
  on delete cascade;

create trigger domain_update_at
  before update on pareto.domain
    for each row
      execute function pareto.update_at();
