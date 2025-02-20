-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.ref_tables (  
  id                    pk,
  id_tenant             fk           not null,
  id_ref_table_type     fk           not null,
  name                  generic_name not null,
  description           description,
  value                 text         not null,
  seq                   int          not null  default 0,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
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

