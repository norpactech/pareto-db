-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.index (
  id                    UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  id_data_object	      UUID         NOT NULL,
  id_rt_index_type      UUID         NOT NULL,
  name                  TEXT         NOT NULL,
  is_unique             BOOLEAN      NOT NULL DEFAULT FALSE,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT         NOT NULL,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT         NOT NULL,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.index
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX index_alt_key 
  ON pareto.index(id_data_object, LOWER(name));

ALTER TABLE pareto.index
  ADD CONSTRAINT index_data_object
  FOREIGN KEY (id_data_object)
  REFERENCES pareto.data_object(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.index
    FOR EACH ROW
      EXECUTE FUNCTION update_at();