-- --------------------------------------------------------------------------------------
-- Validate full_name - Given, Middle, and Sir Name
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_full_name;
CREATE FUNCTION pareto.is_full_name(
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

  IF (in_value ~ '^[A-Za-z]{1,32}([-\'' ][A-Za-z]{1,32})*$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'The name must only contain letters, spaces, apostrophes (''), or hyphens (-), with each part up to 32 characters long. Consecutive apostrophes or hyphens are not allowed.');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


