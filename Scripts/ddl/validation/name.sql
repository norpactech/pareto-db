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

-- RegExp

  IF in_value ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid name format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


