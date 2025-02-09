-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.user (  
  id                    uuid         not null default gen_random_uuid(),
  username              varchar(50)  not null,
  email                 varchar(100) not null,
  full_name             varchar(100) not null,
  created_at            timestamptz  not null  default current_timestamp,
  created_by            varchar(50)  not null,
  updated_at            timestamptz  not null  default current_timestamp,
  updated_by            varchar(50)  not null,
  is_active             boolean      not null  default true
);

alter table pareto.user
  add primary key (id);

create unique index user_alt_key on pareto.user(lower(username));
create unique index user_email on pareto.user(lower(email));

create trigger user_update_at
  before update on pareto.user
    for each row
      execute function pareto.update_at();
