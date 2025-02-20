-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.tenant (
  id                    pk,
  name                  generic_name not null,
  description           description,
  copyright             text,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

ALTER TABLE pareto.tenant
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX tenant_alt_key on pareto.tenant(LOWER(name));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.tenant
    FOR EACH ROW
      EXECUTE FUNCTION update_at();