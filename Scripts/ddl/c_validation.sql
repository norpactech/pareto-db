-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.validation (
  id                    UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  id_tenant             UUID         NOT NULL,
  id_rt_validation_type UUID         NOT NULL,
  name                  TEXT         NOT NULL,
  description           TEXT,
  error_msg             TEXT         NOT NULL,
  expression            TEXT         NOT NULL,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT         NOT NULL,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT         NOT NULL,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.validation
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX validation_alt_key on pareto.validation(LOWER(name));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.validation
    FOR EACH ROW
      EXECUTE FUNCTION update_at();