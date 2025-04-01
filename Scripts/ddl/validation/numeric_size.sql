-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate numeric_size - Small, Medium, Large
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_numeric_size(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

-- Enum

  IF LOWER(in_value) IN ('small', 'medium', 'large') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid numeric_size format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


