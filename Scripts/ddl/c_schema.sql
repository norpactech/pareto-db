-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.schema (  
  id                    pk,
  id_tenant             fk           NOT NULL,
  name                  generic_name NOT NULL,
  description           description,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

ALTER TABLE pareto.schema
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX schema_alt_key 
  ON pareto.schema(id_tenant, LOWER(name));

ALTER TABLE pareto.schema
  ADD CONSTRAINT schema_tenant
  FOREIGN KEY (id_tenant)
  REFERENCES pareto.tenant(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.schema
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
