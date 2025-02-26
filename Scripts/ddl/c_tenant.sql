-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.tenant (
  id                    UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  name                  TEXT         NOT NULL,
  description           TEXT,
  copyright             TEXT,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT         NOT NULL,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT         NOT NULL,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.tenant
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX tenant_alt_key on pareto.tenant(LOWER(name));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.tenant
    FOR EACH ROW
      EXECUTE FUNCTION update_at();