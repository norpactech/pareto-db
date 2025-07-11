-- ---------------------------------------------------------------------------------------
-- Table: pareto.data_index. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.data_index CASCADE;

CREATE TABLE pareto.data_index (
  id                               UUID             NOT NULL    DEFAULT GEN_RANDOM_UUID(), 
  id_data_object                   UUID             NOT NULL, 
  id_rt_index_type                 UUID             NULL, 
  name                             VARCHAR(32)      NOT NULL    CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  created_at                       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.data_index ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX data_index_alt_key
    ON pareto.data_index(id_data_object, LOWER(name));

ALTER TABLE pareto.data_index
  ADD CONSTRAINT data_index_id_data_object
  FOREIGN KEY (id_data_object)
  REFERENCES pareto.data_object(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.data_index
  ADD CONSTRAINT data_index_id_rt_index_type
  FOREIGN KEY (id_rt_index_type)
  REFERENCES pareto.ref_tables(id)
  ON DELETE SET NULL;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.data_index 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
