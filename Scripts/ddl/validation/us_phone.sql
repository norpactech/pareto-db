-- --------------------------------------------------------------------------------------
-- Validate us_phone - United State Phone without Extension
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_us_phone;
CREATE FUNCTION pareto.is_us_phone(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pareto.pg_val
AS $$
DECLARE

  v_result pareto.pg_val;

BEGIN

  IF (in_value ~ '^\d{3}-\d{3}-\d{4}$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid US Phone. Only ###-###-#### is Valid');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


