-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.property_type (  
  id                    UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  id_tenant             UUID         NOT NULL,
  id_rt_data_type       UUID         NOT NULL,
  name                  TEXT         NOT NULL,
  description           TEXT,
  length                INT,
  precision             INT,
  is_nullable           BOOLEAN      NOT NULL,
  default_value         TEXT,
  validation            TEXT,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT         NOT NULL,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT         NOT NULL,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.property_type
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX property_type_alt_key 
  ON pareto.property_type(id_tenant, LOWER(name));

ALTER TABLE pareto.property_type
  ADD CONSTRAINT property_type_tenant
  FOREIGN KEY (id_tenant)
  REFERENCES pareto.tenant(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE pareto.property_type
  ADD CONSTRAINT property_type_rt_data_type
  FOREIGN KEY (id_rt_data_type)
  REFERENCES pareto.ref_tables(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.property_type
    FOR EACH ROW
      EXECUTE FUNCTION update_at();