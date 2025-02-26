-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

DO $$ 
DECLARE

  v_id_tenant fk;
  v_id_schema fk;
  v_id_domain fk;
  v_id_domain_object fk;

BEGIN

  SELECT id INTO v_id_tenant FROM pareto.tenant WHERE name = 'system';
  SELECT id INTO v_id_schema FROM pareto.schema WHERE id_tenant = v_id_tenant and name = 'system';
  SELECT id INTO v_id_domain FROM pareto.domain WHERE id_schema = v_id_schema and name = 'system';

  INSERT INTO pareto.domain_object (id_domain, name, description, has_audit, created_by, updated_by)
    VALUES (v_id_domain, 'ref_tables', 'Reference Tables', true, 'loader', 'loader')
      RETURNING id INTO v_id_domain_object;
  
  INSERT INTO pareto.object_attribute (id_domain_object, name, is_nullable, seq, created_by, updated_by)
    VALUES (v_id_domain_object, 'id_tenant', false, 1, 'loader', 'loader');
  
  INSERT INTO pareto.object_attribute (id_domain_object, name, is_nullable, seq, created_by, updated_by)
    VALUES (v_id_domain_object, 'id_ref_table_type', false, 2, 'loader', 'loader');

  INSERT INTO pareto.object_attribute (id_domain_object, name, is_nullable, seq, created_by, updated_by)
    VALUES (v_id_domain_object, 'name', false, 3, 'loader', 'loader');

  INSERT INTO pareto.object_attribute (id_domain_object, name, is_nullable, seq, created_by, updated_by)
    VALUES (v_id_domain_object, 'description', false, 4, 'loader', 'loader');

  INSERT INTO pareto.object_attribute (id_domain_object, name, is_nullable, seq, created_by, updated_by)
    VALUES (v_id_domain_object, 'value', false, 5, 'loader', 'loader');

  INSERT INTO pareto.object_attribute (id_domain_object, name, is_nullable, seq, created_by, updated_by)
    VALUES (v_id_domain_object, 'seq', false, 6, 'loader', 'loader');
  
END $$;