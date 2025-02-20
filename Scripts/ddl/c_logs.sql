-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create table pareto.logs (  
  id                    pk,
  created_at            timestamp_at,
  created_by            text          not null default 'unavailable',
  level                 text          not null check (level in ('DEBUG','INFO','WARNING','ERROR','CRITICAL')),
  message               text          not null,
  service_name          text          not null,
  metadata JSONB default '{}'::JSONB
);

alter table pareto.logs
  add primary key (id);

create index logs_created_at   on pareto.logs (created_at desc);
create index logs_level        on pareto.logs (level);
create index logs_service_name on pareto.logs (service_name);