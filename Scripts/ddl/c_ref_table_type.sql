-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.ref_table_type (
  id                    pk,
  name                  TEXT         NOT NULL,
  description           description,
  is_global             BOOLEAN      NOT NULL,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

ALTER TABLE pareto.ref_table_type
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX ref_table_type_alt_key on pareto.ref_table_type(LOWER(name));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.ref_table_type
    FOR EACH ROW
      EXECUTE FUNCTION update_at();