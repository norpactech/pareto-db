-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate us_zip_code - United States Zip Codes
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_us_zip_code(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

-- RegExp

  IF in_value ~ '^\d{5}(-\d{4})?$' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid us_zip_code format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


