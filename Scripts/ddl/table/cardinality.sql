-- ---------------------------------------------------------------------------------------
-- Table: pareto.cardinality. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.cardinality CASCADE;

CREATE TABLE pareto.cardinality (
  id                               UUID             NOT NULL, 
  id_property                      UUID             NOT NULL, 
  id_object_reference              UUID             NOT NULL, 
  id_rt_cardinality                UUID             NOT NULL, 
  id_rt_cardinality_strength       UUID             NOT NULL, 
  has_referencial_action           BOOLEAN          NOT NULL, 
  created_at                       TIMESTAMPTZ      NOT NULL, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMPTZ      NOT NULL, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL    DEFAULT TRUE
);

ALTER TABLE pareto.cardinality ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX cardinality_alt_key
    ON pareto.cardinality(id_property, id_object_reference);

ALTER TABLE pareto.cardinality
  ADD CONSTRAINT cardinality_id_property
  FOREIGN KEY (id_property)
  REFERENCES pareto.property(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.cardinality
  ADD CONSTRAINT cardinality_id_object_reference
  FOREIGN KEY (id_object_reference)
  REFERENCES pareto.data_object(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.cardinality
  ADD CONSTRAINT cardinality_id_rt_cardinality
  FOREIGN KEY (id_rt_cardinality)
  REFERENCES pareto.ref_tables(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.cardinality
  ADD CONSTRAINT cardinality_id_rt_cardinality_strength
  FOREIGN KEY (id_rt_cardinality_strength)
  REFERENCES pareto.ref_tables(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.cardinality 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
