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

  IF (in_value ~ '^[A-Za-z]{1,32}([-\'' ][A-Za-z]{1,32})*$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'The name must only contain letters, spaces, apostrophes ('), or hyphens (-), with each part up to 32 characters long. Consecutive apostrophes or hyphens are not allowed.');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


