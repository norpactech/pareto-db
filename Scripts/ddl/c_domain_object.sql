-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.domain_object (
  id                    pk,
  id_domain             fk           NOT NULL,
  name                  TEXT         NOT NULL,
  description           description,
  has_identifier        BOOLEAN      NOT NULL DEFAULT TRUE,
  has_audit             BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

ALTER TABLE pareto.domain_object
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX domain_object_alt_key 
  ON pareto.domain_object(id_domain, LOWER(name));

ALTER TABLE pareto.domain_object
  ADD CONSTRAINT domain_object_domain
  FOREIGN KEY (id_domain)
  REFERENCES pareto.domain(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.domain_object
    FOR EACH ROW
      EXECUTE FUNCTION update_at();