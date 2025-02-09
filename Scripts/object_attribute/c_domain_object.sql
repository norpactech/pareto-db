-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.domain_object (
  
  id                    uuid        default gen_random_uuid(),
  id_domain             uuid        not null,
  name                  varchar(50) not null,
  description           text,
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
);

alter table pareto.domain_object
  add primary key (id);

create unique index domain_object_alt_key 
  on pareto.domain_object(id_domain, lower(name));

alter table pareto.domain_object
  add constraint domain_object_domain
  foreign key (id_domain)
  references pareto.domain(id)
  on update cascade
  on delete cascade;

create trigger domain_object_update_at
  before update on pareto.domain_object
    for each row
      execute function pareto.update_at();
