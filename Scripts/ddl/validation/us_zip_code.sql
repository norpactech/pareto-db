-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate us_zip_code - United States Zip Codes
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.is_us_zip_code(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pareto.pg_val
AS $$
DECLARE

  v_result pareto.pg_val;

BEGIN

  IF (in_value ~ '^\d{5}(-\d{4})?$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid US Zip Code. Only ####[-####] is Valid');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


