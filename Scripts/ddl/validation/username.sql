-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate username - System Username Validation
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_username(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

-- RegExp

  IF in_value ~ '^[a-zA-Z][a-zA-Z0-9_-]{2,31}$' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid username format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


