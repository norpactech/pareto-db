-- -----------------------------------------------------------------------------
-- Table: pareto.index. Generated by Pareto Factory™ "Be Consistent"
-- -----------------------------------------------------------------------------
CREATE TABLE pareto.index (
  id                               UUID             NOT NULL  DEFAULT GEN_RANDOM_UUID(), 
  id_data_object                   UUID             NOT NULL, 
  id_rt_index_type                 UUID             NOT NULL, 
  name                             VARCHAR(32)      NOT NULL  CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  created_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL  DEFAULT TRUE
);

ALTER TABLE pareto.index ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX index_alt_key 
    ON pareto.index(id_data_object, LOWER(name));

ALTER TABLE pareto.index
  ADD CONSTRAINT index_ref_tables
  FOREIGN KEY (id_rt_index_type)
  REFERENCES pareto.ref_tables(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.index 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();