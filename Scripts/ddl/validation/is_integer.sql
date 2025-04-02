-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate is_integer - Integer Value
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_is_integer(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

  IF LOWER(in_value) = 'pg_typeof(value) IN ('integer')' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Is the value an integer');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


