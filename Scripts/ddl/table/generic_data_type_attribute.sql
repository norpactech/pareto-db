-- ---------------------------------------------------------------------------------------
-- Table: pareto.generic_data_type_attribute. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.generic_data_type_attribute CASCADE;

CREATE TABLE pareto.generic_data_type_attribute (
  id                               UUID             NOT NULL    DEFAULT GEN_RANDOM_UUID(), 
  id_generic_data_type             UUID             NOT NULL, 
  id_rt_attr_data_type             UUID             NOT NULL, 
  name                             VARCHAR(32)      NOT NULL    CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  description                      TEXT             NULL, 
  created_at                       TIMESTAMPTZ      NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMPTZ      NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.generic_data_type_attribute ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX generic_data_type_attribute_alt_key
    ON pareto.generic_data_type_attribute(id_generic_data_type, LOWER(name));

ALTER TABLE pareto.generic_data_type_attribute
  ADD CONSTRAINT generic_data_type_attribute_id_generic_data_type
  FOREIGN KEY (id_generic_data_type)
  REFERENCES pareto.generic_data_type(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.generic_data_type_attribute
  ADD CONSTRAINT generic_data_type_attribute_id_rt_attr_data_type
  FOREIGN KEY (id_rt_attr_data_type)
  REFERENCES pareto.ref_tables(id);

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.generic_data_type_attribute 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
