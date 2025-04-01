-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate boolean - True, False
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_boolean(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

-- Enum

  IF LOWER(in_value) IN ('true', 'false') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid boolean format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


