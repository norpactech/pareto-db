-- --------------------------------------------------------------------------------------
-- Validate us_state - United States 2 Char State Code
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.is_us_state;
CREATE FUNCTION pareto.is_us_state(
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

  IF (LOWER(in_value) IN ('al', 'ak', 'az', 'ar', 'ca', 'co', 'ct', 'de', 'fl', 'ga', 'hi', 'id', 'il', 'in', 'ia', 'ks', 'ky', 'la', 'me', 'md', 'ma', 'mi', 'mn', 'ms', 'mo', 'mt', 'ne', 'nv', 'nh', 'nj', 'nm', 'ny', 'nc', 'nd', 'oh', 'ok', 'or', 'pa', 'ri', 'sc', 'sd', 'tn', 'tx', 'ut', 'vt', 'va', 'wa', 'wv', 'wi', 'wy')) THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid US State Abbreviation');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


