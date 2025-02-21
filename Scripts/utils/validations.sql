-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

-- --------------------------------------------------------
-- Validate generic_name
-- --------------------------------------------------------
-- --------------------------------------------------------
-- Validate generic_name
-- --------------------------------------------------------
CREATE OR REPLACE FUNCTION is_generic_name(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN
    
  IF in_value ~* '^[A-Za-z]+(['' -][A-Za-z]+)*$' THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid generic_name format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;