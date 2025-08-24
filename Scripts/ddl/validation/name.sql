-- --------------------------------------------------------------------------------------
-- Validate name - Generic Name with Few Special Characters
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_name;
CREATE FUNCTION pareto.is_name(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pareto.pg_val
AS $$
DECLARE

  v_result pareto.pg_val;

BEGIN
  
  -- -------------------------------------------
  -- Null validations are checked elsewhere
  -- -------------------------------------------
  IF (in_value IS NULL) THEN
    v_result := (TRUE, in_attribute, NULL);
    return v_result;
  END IF;

  IF (in_value ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'The value must be between 1 and 32 characters long and can only contain letters, numbers, spaces, hyphens, commas, periods, ampersands, apostrophes, or parentheses.');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


