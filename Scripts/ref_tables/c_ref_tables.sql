-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.ref_tables (
  
  id uuid                                     default gen_random_uuid(),
  id_tenant             uuid        not null,
  id_ref_table_type     uuid        not null,
  name                  varchar(50) not null,
  description           text,
  value                 text        not null,
  seq                   int         not null  default 0,
  created_at            timestamptz not null  default current_timestamp,
  created_by            varchar(50) not null,
  updated_at            timestamptz not null  default current_timestamp,
  updated_by            varchar(50) not null,
  is_active             boolean     not null  default true
);

alter table pareto.ref_tables
  add primary key (id);

create unique index ref_tables_alt_key 
    on pareto.ref_tables(id_tenant, id_ref_table_type, lower(name));

alter table pareto.ref_tables
  add constraint ref_tables_tenant
  foreign key (id_tenant)
  references pareto.tenant(id)
  on update cascade
  on delete cascade;

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

