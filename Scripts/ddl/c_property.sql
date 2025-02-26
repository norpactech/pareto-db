-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.property (  
  id                    UUID         NOT NULL DEFAULT gen_random_uuid(),
  id_object             UUID         NOT NULL,
  id_property_type      UUID         NOT NULL,
  name                  TEXT         NOT NULL,
  description           TEXT,
  validation            TEXT,
  length                INT,
  precision             INT,
  is_nullable           BOOLEAN       NOT NULL  DEFAULT FALSE,
  default_value         TEXT,
  sequence              INT           NOT NULL,
  created_at            TIMESTAMPTZ   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT,
  updated_at            TIMESTAMPTZ   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT,
  is_active             BOOLEAN       NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.property
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX property_alt_key 
  ON pareto.property(id_object, LOWER(name));

ALTER TABLE pareto.property
  ADD CONSTRAINT property_object
  FOREIGN KEY (id_object)
  REFERENCES pareto.object(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.property
    FOR EACH ROW
      EXECUTE FUNCTION update_at();