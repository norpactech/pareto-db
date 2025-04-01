-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate package - Package Structure (i.e. com.norpactech.pareto)
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_package(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

-- RegExp

  IF in_value ~ '^[a-z0-9]+(\.[a-z0-9]+)*$' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid package format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


