-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.customer (
  
  id                    pk,  
  id_tenant             fk          not null,
  customer_id           alt_key,
  email                 email       not null,
  cell                  phone_number,
  description           description,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

alter table pareto.customer
  add primary key (id);

create unique index alt_key 
  on pareto.customer(id_tenant, lower(customer_id));

create unique index email 
  on pareto.customer(id_tenant, lower(email));

alter table pareto.customer
  add constraint tenant
  foreign key (id_tenant)
  references pareto.tenant(id)
  on update cascade
  on delete cascade;

create trigger customer_update_at
  before update on pareto.customer
    for each row
      execute function pareto.update_at();
