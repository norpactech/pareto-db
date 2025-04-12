-- ---------------------------------------------------------------------------------------
-- Table: pareto.index_property. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.index_property CASCADE;

CREATE TABLE pareto.index_property (
  id                               UUID             NOT NULL    DEFAULT GEN_RANDOM_UUID(), 
  id_index                         UUID             NOT NULL, 
  id_property                      UUID             NOT NULL, 
  id_rt_sort_order                 UUID             NOT NULL, 
  sequence                         INTEGER          NOT NULL, 
  created_at                       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.index_property ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX index_property_alt_key
    ON pareto.index_property(id_index, id_property);

ALTER TABLE pareto.index_property
  ADD CONSTRAINT index_property_id_index
  FOREIGN KEY (id_index)
  REFERENCES pareto.index(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.index_property
  ADD CONSTRAINT index_property_id_property
  FOREIGN KEY (id_property)
  REFERENCES pareto.property(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.index_property
  ADD CONSTRAINT index_property_id_rt_sort_order
  FOREIGN KEY (id_rt_sort_order)
  REFERENCES pareto.ref_tables(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.index_property 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
