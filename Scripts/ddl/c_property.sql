-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.property (  
  id                    UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  id_data_object        UUID         NOT NULL,
  sequence              INT          NOT NULL,
  alt_key_sequence      INT,
  name                  TEXT         NOT NULL,
  description           TEXT,
  data_type             TEXT,
  validation            TEXT,
  length                INT,
  precision             INT,
  is_nullable           BOOLEAN      NOT NULL  DEFAULT FALSE,
  default_value         TEXT,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT         NOT NULL,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT         NOT NULL,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.property
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX property_alt_key 
  ON pareto.property(id_data_object, LOWER(name));

ALTER TABLE pareto.property
  ADD CONSTRAINT property_data_object
  FOREIGN KEY (id_data_object)
  REFERENCES pareto.data_object(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.property
    FOR EACH ROW
      EXECUTE FUNCTION update_at();