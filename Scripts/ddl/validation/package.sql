-- --------------------------------------------------------------------------------------
-- Validate package - Package Structure (i.e. com.norpactech.pareto)
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_package;
CREATE FUNCTION pareto.is_package(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pareto.pg_val
AS $$
DECLARE

  v_result pareto.pg_val;

BEGIN

  IF (in_value ~ '^[a-z0-9]+(\.[a-z0-9]+)*$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Only [lower-case, number, and .] are valid');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


