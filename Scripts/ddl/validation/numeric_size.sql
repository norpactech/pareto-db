-- --------------------------------------------------------------------------------------
-- Validate numeric_size - Small, Medium, Large
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_numeric_size;
CREATE FUNCTION pareto.is_numeric_size(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pareto.pg_val
AS $$
DECLARE

  v_result pareto.pg_val;

BEGIN

  IF (LOWER(in_value) IN ('small', 'medium', 'large')) THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Only Small, Medium, and Large is Valid');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


