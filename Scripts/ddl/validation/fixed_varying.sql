-- --------------------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
--  
-- For license details, see the LICENSE file in this project root.
--
-- --------------------------------------------------------------------------------------
-- Validate fixed_varying - Is the value Fixed or Varying
-- --------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.is_fixed_varying(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN

  IF (LOWER(in_value) IN ('fixed', 'varying')) THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'The value must be either ''Fixed'' or ''Varying''');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


