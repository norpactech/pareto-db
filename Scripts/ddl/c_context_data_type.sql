-- -----------------------------------------------------------------------------
-- Table: pareto.context_data_type. Generated by Pareto Factory™ "Be Consistent"
-- -----------------------------------------------------------------------------
CREATE TABLE pareto.context_data_type (
  id                               UUID             NOT NULL  DEFAULT GEN_RANDOM_UUID(), 
  id_generic_data_type             UUID             NOT NULL,
  sequence                         INT              NOT NULL, 
  name                             VARCHAR(32)      NOT NULL  CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  alias                            VARCHAR(32)      NOT NULL, 
  description                      TEXT, 
  context_value                    VARCHAR(32)      NOT NULL, 
  created_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL  DEFAULT TRUE
);

ALTER TABLE pareto.context_data_type ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX context_data_type_alt_key 
    ON pareto.context_data_type(id_generic_data_type, LOWER(name));

ALTER TABLE pareto.context_data_type
  ADD CONSTRAINT context_data_type_id_generic_data_type
  FOREIGN KEY (id_generic_data_type)
  REFERENCES pareto.generic_data_type(id);

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.context_data_type 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();