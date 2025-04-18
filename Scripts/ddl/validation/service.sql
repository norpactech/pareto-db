-- --------------------------------------------------------------------------------------
-- Validate service - Service Name
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_service;
CREATE FUNCTION pareto.is_service(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pareto.pg_val
AS $$
DECLARE

  v_result pareto.pg_val;

BEGIN

  IF (in_value ~ '^[a-z][a-zA-Z0-9_]*$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Must start with a lowercase letter and contain only letters, digits, and underscores');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


