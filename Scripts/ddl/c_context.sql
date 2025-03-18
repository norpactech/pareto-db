-- -----------------------------------------------------------------------------
-- Table: pareto.context. Generated by Pareto Factory™ "Be Consistent"
-- -----------------------------------------------------------------------------
CREATE TABLE pareto.context (
  id                               UUID             NOT NULL  DEFAULT GEN_RANDOM_UUID(), 
  name                             VARCHAR(32)      NOT NULL  CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  description                      TEXT, 
  created_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL  DEFAULT TRUE
);

ALTER TABLE pareto.context ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX context_alt_key 
    ON pareto.context(LOWER(name));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.context 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
