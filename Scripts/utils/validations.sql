-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION is_email(
  col   TEXT,
  email TEXT
) 
RETURNS pg_val
AS $$
DECLARE

  v_result pg_val;

BEGIN
    
  IF email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
    v_result := (TRUE, col, NULL);  -- Passed validation
  ELSE
    v_result := (FALSE, col, 'Invalid email format');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;