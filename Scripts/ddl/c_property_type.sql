-- -----------------------------------------------------------------------------
-- Table: pareto.property_type. Generated by Pareto Factory™ "Be Consistent"
-- -----------------------------------------------------------------------------

CREATE TABLE pareto.property_type (
  id                               UUID             NOT NULL  DEFAULT GEN_RANDOM_UUID(), 
  id_tenant                        UUID             NOT NULL, 
  id_rt_data_type                  UUID             NOT NULL, 
  id_validation                    UUID             NULL, 
  name                             VARCHAR(32)      NOT NULL  CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  description                      TEXT             NULL, 
  length                           INTEGER          NULL, 
  precision                        INTEGER          NULL, 
  is_nullable                      BOOLEAN          NOT NULL, 
  default_value                    TEXT             NULL, 
  created_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL  DEFAULT TRUE
);

ALTER TABLE pareto.property_type ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX property_type_alt_key 
    ON pareto.property_type(id_tenant, LOWER(name));

ALTER TABLE pareto.property_type
  ADD CONSTRAINT property_type_ref_tables
  FOREIGN KEY (id_rt_data_type)
  REFERENCES pareto.ref_tables(id)
  ON DELETE CASCADE;

ALTER TABLE pareto.property_type
  ADD CONSTRAINT property_type_validation
  FOREIGN KEY (id_validation)
  REFERENCES pareto.validation(id)
  ON DELETE SET NULL;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.property_type 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();