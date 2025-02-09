-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.object_attribute (
  
  id                    uuid        default gen_random_uuid(),
  id_domain_object      uuid        not null,
  name                  varchar(50) not null,
  description           text,
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
);

alter table pareto.object_attribute
  add primary key (id);

create unique index object_attribute_alt_key 
  on pareto.object_attribute(id_domain_object, lower(name));

alter table pareto.object_attribute
  add constraint object_attribute_domain_object
  foreign key (id_domain_object)
  references pareto.domain_object(id)
  on update cascade
  on delete cascade;

create trigger object_attribute_update_at
  before update on pareto.object_attribute
    for each row
      execute function pareto.update_at();
