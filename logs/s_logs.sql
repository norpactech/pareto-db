-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

create procedure pareto.i_logs(
  in in_level         varchar,
  in in_message       text,
  in in_service_name  varchar,
  in in_created_by    varchar,
  in in_metadata      jsonb
)
language plpgsql
as $$
declare
begin

  insert into pareto.logs (
    level,
    message,
    service_name,
    created_by,
	metadata
  )
  values (
    in_level,
    in_message,
    in_service_name,
    in_created_by,
	in_metadata
  );

end;
$$;



