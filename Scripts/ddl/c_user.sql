-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.user (  
  id                    pk,
  username              username,
  email                 email         not null,
  full_name             generic_name  not null,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

alter table pareto.user
  add primary key (id);

create unique index user_alt_key on pareto.user(lower(username));
create unique index user_email on pareto.user(lower(email));

create trigger update_at
  before update on pareto.user
    for each row
      execute function update_at();
