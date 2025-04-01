-- ---------------------------------------------------------------------------------------
-- Table: pareto.project_component. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.project_component CASCADE;

CREATE TABLE pareto.project_component (
  id                               UUID             NOT NULL    DEFAULT GEN_RANDOM_UUID(), 
  id_project                       UUID             NOT NULL, 
  id_context                       UUID             NOT NULL, 
  id_plugin                        UUID             NOT NULL, 
  name                             VARCHAR(32)      NOT NULL    CHECK (name ~ '^[A-Za-z0-9_][A-Za-z0-9\s\-,\.&''()*_:]{0,30}[A-Za-z0-9_]$'), 
  description                      TEXT             NULL, 
  subpackage                       VARCHAR(32)      NOT NULL    CHECK (subpackage ~ '^[a-z0-9]+(\.[a-z0-9]+)*$'), 
  created_at                       TIMESTAMPTZ      NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMPTZ      NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.project_component ADD PRIMARY KEY (id);
CREATE UNIQUE INDEX project_component_alt_key
    ON pareto.project_component(id_project, LOWER(name));

ALTER TABLE pareto.project_component
  ADD CONSTRAINT project_component_id_project
  FOREIGN KEY (id_project)
  REFERENCES pareto.project(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.project_component
  ADD CONSTRAINT project_component_id_context
  FOREIGN KEY (id_context)
  REFERENCES pareto.context(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.project_component
  ADD CONSTRAINT project_component_id_plugin
  FOREIGN KEY (id_plugin)
  REFERENCES pareto.plugin(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.project_component 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
