-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate service - Service Name
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_service(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

  IF (in_value ~ '^[a-z][a-zA-Z0-9_]*$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Must start with a lowercase letter and contain only letters, digits, and underscores');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


