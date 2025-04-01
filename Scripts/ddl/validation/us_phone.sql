-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate us_phone - United State Phone without Extension
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_us_phone(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

-- RegExp

  IF in_value ~ '^\d{3}-\d{3}-\d{4}$' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid us_phone format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


