-- ---------------------------------------------------------------------------------------
-- Table: pareto.property. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.property CASCADE;

CREATE TABLE pareto.property (
  id                               UUID             NOT NULL    DEFAULT GEN_RANDOM_UUID(), 
  id_data_object                   UUID             NOT NULL, 
  id_generic_data_type             UUID             NOT NULL, 
  id_generic_property_type         UUID             NULL, 
  id_validation                    UUID             NULL, 
  sequence                         INTEGER          NOT NULL, 
  name                             VARCHAR(32)      NOT NULL    CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  description                      TEXT             NULL, 
  length                           INTEGER          NULL, 
  scale                            INTEGER          NULL, 
  is_nullable                      BOOLEAN          NOT NULL    DEFAULT FALSE, 
  default_value                    TEXT             NULL, 
  created_at                       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.property ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX property_alt_key
    ON pareto.property(id_data_object, LOWER(name));

ALTER TABLE pareto.property
  ADD CONSTRAINT property_id_data_object
  FOREIGN KEY (id_data_object)
  REFERENCES pareto.data_object(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.property
  ADD CONSTRAINT property_id_generic_data_type
  FOREIGN KEY (id_generic_data_type)
  REFERENCES pareto.generic_data_type(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.property
  ADD CONSTRAINT property_id_generic_property_type
  FOREIGN KEY (id_generic_property_type)
  REFERENCES pareto.generic_property_type(id)
  ON DELETE SET NULL;
    
ALTER TABLE pareto.property
  ADD CONSTRAINT property_id_validation
  FOREIGN KEY (id_validation)
  REFERENCES pareto.validation(id)
  ON DELETE SET NULL;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.property 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
