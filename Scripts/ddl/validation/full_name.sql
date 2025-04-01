-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate full_name - Given, Middle, and Sir Name
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_full_name(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

-- RegExp

  IF in_value ~ '^[A-Za-z]{1,32}([-\'' ][A-Za-z]{1,32})*$' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid full_name format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


