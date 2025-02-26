-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.schema (  
  id                    UUID         NOT NULL DEFAULT gen_random_uuid(),
  id_tenant             UUID         NOT NULL,
  name                  TEXT         NOT NULL,
  description           TEXT,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
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
