-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate name - Generic Name with Few Special Characters
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_name(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

  IF (in_value ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'The value must be between 1 and 32 characters long and can only contain letters, numbers, spaces, hyphens, commas, periods, ampersands, apostrophes, or parentheses.');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


