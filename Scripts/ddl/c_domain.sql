-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.domain (  
  id                    pk,
  id_schema             fk           NOT NULL,
  name                  generic_name NOT NULL,
  description           description,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

ALTER TABLE pareto.domain
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX domain_alt_key 
  ON pareto.schema(id_tenant, LOWER(name));

ALTER TABLE pareto.domain
  ADD CONSTRAINT domain_schema
  FOREIGN KEY (id_schema)
  REFERENCES pareto.schema(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

CREATE TRIGGER domain_update_at
  BEFORE UPDATE ON pareto.domain
    FOR EACH ROW
      EXECUTE FUNCTION update_at();