-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate email - Email Address
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_email(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

-- RegExp

  IF in_value ~ '^[A-Za-z0-9]+([._%+-][A-Za-z0-9]+)*@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid email format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


