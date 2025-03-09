-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.object (
  id                    UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  id_schema             UUID         NOT NULL,
  name                  TEXT         NOT NULL,
  description           TEXT,
  has_identifier        BOOLEAN      NOT NULL DEFAULT TRUE,
  has_audit             BOOLEAN      NOT NULL DEFAULT TRUE,
  has_active            BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT         NOT NULL,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT         NOT NULL,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.object
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX object_alt_key 
  ON pareto.object(id_schema, LOWER(name));

ALTER TABLE pareto.object
  ADD CONSTRAINT object_schema
  FOREIGN KEY (id_schema)
  REFERENCES pareto.schema(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.object
    FOR EACH ROW
      EXECUTE FUNCTION update_at();