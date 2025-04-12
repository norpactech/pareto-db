-- --------------------------------------------------------------------------------------
-- Validate fixed_varying - Is the value Fixed or Varying
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_fixed_varying;
CREATE FUNCTION pareto.is_fixed_varying(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pareto.pg_val
AS $$
DECLARE

  v_result pareto.pg_val;

BEGIN

  IF (LOWER(in_value) IN ('fixed', 'varying')) THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'The value must be either ''Fixed'' or ''Varying''');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


