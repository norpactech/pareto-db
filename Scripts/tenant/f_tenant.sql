-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE FUNCTION pareto.i_tenant(
  IN name        text,
  IN description text,
  IN copyright   text,
  IN created_by  text
)
RETURNS TABLE (
  id         uuid,
  updated_at timestamptz
)
AS $$
DECLARE

  v_id         uuid;
  v_updated_at timestamptz;

BEGIN

  
  
  INSERT INTO pareto.tenant (
    name,
    description,
    copyright,
    created_by,
    updated_by
  )
  VALUES (
    name,
    description,
    copyright,
    created_by,
    created_by
  )
  RETURNING tenant.id, tenant.updated_at INTO v_id, v_updated_at;
  
  RETURN QUERY SELECT v_id, v_updated_at;
  
END;
$$ LANGUAGE plpgsql;
