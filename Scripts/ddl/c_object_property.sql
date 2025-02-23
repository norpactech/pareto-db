-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.object_property (  
  id                    pk,
  id_domain_object      fk            NOT NULL,
  id_property_type      fk,
  name                  TEXT          NOT NULL,
  description           description,
  validation            TEXT,
  length                INT,
  precision             INT,
  is_nullable           BOOLEAN       NOT NULL  DEFAULT FALSE,
  default_value         TEXT,
  seq                   INT           NOT NULL,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

ALTER TABLE pareto.object_property
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX object_property_alt_key 
  ON pareto.object_property(id_domain_object, LOWER(name));

ALTER TABLE pareto.object_property
  ADD CONSTRAINT object_property_domain_object
  FOREIGN KEY (id_domain_object)
  REFERENCES pareto.domain_object(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.object_property
    FOR EACH ROW
      EXECUTE FUNCTION update_at();