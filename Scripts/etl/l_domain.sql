-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

DO $$ 
DECLARE

  v_id_tenant fk;
  v_id_schema fk;

BEGIN

  SELECT id INTO v_id_tenant FROM pareto.tenant WHERE name = 'system';
  SELECT id INTO v_id_schema FROM pareto.schema WHERE id_tenant = v_id_tenant and name = 'system';
  
  INSERT INTO pareto.domain (id_schema, name, description, created_by, updated_by)
    VALUES (v_id_schema, 'pareto', 'Pareto System Problem Domain', 'loader', 'loader');
  
END $$;