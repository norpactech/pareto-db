-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.logs (  
  id                    uuid         not null default gen_random_uuid(),
  created_at            timestamptz  not null default current_timestamp,
  level                 varchar(10)  not null check (level in ('DEBUG','INFO','WARNING','ERROR','CRITICAL')),
  message               text         not null,
  service_name          varchar(255) not null,
  created_by            varchar(50),
  metadata JSONB default '{}'::JSONB
);

alter table pareto.logs
  add primary key (id);

create index logs_created_at   on pareto.logs (created_at desc);
create index logs_level        on pareto.logs (level);
create index logs_service_name on pareto.logs (service_name);