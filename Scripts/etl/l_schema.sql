-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

DO $$ 
DECLARE

  v_id_tenant fk;

BEGIN

  SELECT id INTO v_id_tenant FROM pareto.tenant WHERE name = 'system';
  
  INSERT INTO pareto.schema (id_tenant, name, description, created_by, updated_by)
    VALUES (v_id_tenant, 'system', 'Pareto System Schema', 'loader', 'loader');

END $$;

  
