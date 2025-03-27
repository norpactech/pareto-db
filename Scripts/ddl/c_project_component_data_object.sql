-- ---------------------------------------------------------------------------------------
-- Table: pareto.project_component_data_object. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
CREATE TABLE pareto.project_component_data_object (
  id_project_component             UUID             NOT NULL   , 
  id_data_object                   UUID             NOT NULL   
);

ALTER TABLE pareto.project_component_data_object ADD PRIMARY KEY (id_project_component, id_data_object);

ALTER TABLE pareto.project_component_data_object
  ADD CONSTRAINT project_component_data_object_id_project_component
  FOREIGN KEY (id_project_component)
  REFERENCES pareto.project_component(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.project_component_data_object
  ADD CONSTRAINT project_component_data_object_id_data_object
  FOREIGN KEY (id_data_object)
  REFERENCES pareto.data_object(id)
  ON DELETE CASCADE;