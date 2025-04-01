-- ---------------------------------------------------------------------------------------
-- Table: pareto.validation. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.validation CASCADE;

CREATE TABLE pareto.validation (
  id                               UUID             NOT NULL    DEFAULT GEN_RANDOM_UUID(), 
  id_tenant                        UUID             NOT NULL, 
  id_rt_validation_type            UUID             NOT NULL, 
  name                             VARCHAR(32)      NOT NULL    CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  description                      TEXT             NULL, 
  error_msg                        TEXT             NOT NULL, 
  expression                       TEXT             NOT NULL, 
  created_at                       TIMESTAMPTZ      NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMPTZ      NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.validation ADD PRIMARY KEY (id);
CREATE UNIQUE INDEX validation_alt_key
    ON pareto.validation(id_tenant, LOWER(name));

ALTER TABLE pareto.validation
  ADD CONSTRAINT validation_id_tenant
  FOREIGN KEY (id_tenant)
  REFERENCES pareto.tenant(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.validation
  ADD CONSTRAINT validation_id_rt_validation_type
  FOREIGN KEY (id_rt_validation_type)
  REFERENCES pareto.ref_tables(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.validation 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
