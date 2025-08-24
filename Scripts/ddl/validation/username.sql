-- --------------------------------------------------------------------------------------
-- Validate username - System Username Validation
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_username;
CREATE FUNCTION pareto.is_username(
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

  IF (in_value ~ '^[a-zA-Z][a-zA-Z0-9_-]{2,31}$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'The username must start with a letter, be 3 to 32 characters long, and can only contain letters, numbers, underscores, or hyphens');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


