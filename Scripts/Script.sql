CREATE TABLE pareto.logs (  
  id           UUID DEFAULT gen_random_uuid(),
  created_at   TIMESTAMPTZ   DEFAULT CURRENT_TIMESTAMP,
  created_by   TEXT          DEFAULT 'unavailable',
  level        TEXT,
  message      TEXT,
  service_name TEXT,
  metadata JSONB default '{}'::JSONB
);

ALTER TABLE pareto.logs
  ADD PRIMARY KEY (id);

CREATE INDEX logs_created_at   ON united_bins.logs (created_at DESC);
CREATE INDEX logs_level        ON united_bins.logs (level);
CREATE INDEX logs_service_name ON united_bins.logs (service_name);

-- Insert Logs

CREATE PROCEDURE pareto.i_logs(
  IN in_level         TEXT,
  IN in_message       TEXT,
  IN in_service_name  TEXT,
  IN in_created_by    TEXT,
  IN in_metadata      JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN

  INSERT INTO pareto.logs (
    level,
    message,
    service_name,
    created_by,
    metadata
  )
  VALUES (
    in_level,
    in_message,
    in_service_name,
    in_created_by,
    in_metadata
  );

END;
$$;