-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.ref_tables (  
  id                    UUID         NOT NULL DEFAULT gen_random_uuid(),
  id_tenant             UUID         NOT NULL,
  id_ref_table_type     UUID         NOT NULL,
  name                  TEXT         NOT NULL,
  description           TEXT,
  value                 TEXT         NOT NULL,
  sequence              INT          NOT NULL DEFAULT 0,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.ref_tables
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX ref_tables_alt_key 
    on pareto.ref_tables(id_tenant, id_ref_table_type, LOWER(name));

ALTER TABLE pareto.ref_tables
  ADD CONSTRAINT ref_tables_tenant
  FOREIGN KEY (id_tenant)
  REFERENCES pareto.tenant(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE pareto.ref_tables
  ADD CONSTRAINT ref_tables_ref_table_type
  FOREIGN KEY (id_ref_table_type)
  REFERENCES pareto.ref_table_type(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;
  
CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.ref_tables
    FOR EACH ROW
      EXECUTE FUNCTION update_at();

