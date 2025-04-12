-- ---------------------------------------------------------------------------------------
-- Table: pareto.context_property_type. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.context_property_type CASCADE;

CREATE TABLE pareto.context_property_type (
  id                               UUID             NOT NULL    DEFAULT GEN_RANDOM_UUID(), 
  id_context                       UUID             NOT NULL, 
  id_schema                        UUID             NOT NULL, 
  id_generic_property_type         UUID             NOT NULL, 
  length                           INTEGER          NULL, 
  scale                            INTEGER          NULL, 
  is_nullable                      BOOLEAN          NOT NULL, 
  default_value                    TEXT             NULL, 
  created_at                       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.context_property_type ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX context_property_type_alt_key
    ON pareto.context_property_type(id_context, id_schema, id_generic_property_type);

ALTER TABLE pareto.context_property_type
  ADD CONSTRAINT context_property_type_id_context
  FOREIGN KEY (id_context)
  REFERENCES pareto.context(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.context_property_type
  ADD CONSTRAINT context_property_type_id_schema
  FOREIGN KEY (id_schema)
  REFERENCES pareto.schema(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.context_property_type
  ADD CONSTRAINT context_property_type_id_generic_property_type
  FOREIGN KEY (id_generic_property_type)
  REFERENCES pareto.generic_property_type(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.context_property_type 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
