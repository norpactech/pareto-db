-- ---------------------------------------------------------------------------------------
-- Table: pareto.ref_tables. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.ref_tables CASCADE;

CREATE TABLE pareto.ref_tables (
  id                               UUID             NOT NULL    DEFAULT GEN_RANDOM_UUID(), 
  id_ref_table_type                UUID             NOT NULL, 
  name                             VARCHAR(32)      NOT NULL    CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  description                      TEXT             NULL, 
  value                            TEXT             NOT NULL, 
  sequence                         INTEGER          NOT NULL, 
  created_at                       TIMESTAMPTZ      NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMPTZ      NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.ref_tables ADD PRIMARY KEY (id);
CREATE UNIQUE INDEX ref_tables_alt_key
    ON pareto.ref_tables(id_ref_table_type, LOWER(name));

ALTER TABLE pareto.ref_tables
  ADD CONSTRAINT ref_tables_id_ref_table_type
  FOREIGN KEY (id_ref_table_type)
  REFERENCES pareto.ref_table_type(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.ref_tables 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
