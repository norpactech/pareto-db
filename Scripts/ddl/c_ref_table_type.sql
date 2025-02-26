-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.ref_table_type (
  id                    UUID         NOT NULL DEFAULT gen_random_uuid(),
  name                  TEXT         NOT NULL,
  description           TEXT,
  is_global             BOOLEAN      NOT NULL,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.ref_table_type
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX ref_table_type_alt_key on pareto.ref_table_type(LOWER(name));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.ref_table_type
    FOR EACH ROW
      EXECUTE FUNCTION update_at();