-- --------------------------------------------------------------------------------------
-- Validate email - Email Address
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_email;
CREATE FUNCTION pareto.is_email(
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

  IF (in_value ~ '^[A-Za-z0-9]+([._%+-][A-Za-z0-9]+)*@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid Email Format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


