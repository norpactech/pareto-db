-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.cardinality (  
  id                         UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  id_object                  UUID         NOT NULL,
  id_object_reference        UUID         NOT NULL,
  id_rt_cardinality          UUID         NOT NULL,
  id_rt_cardinality_strength UUID         NOT NULL,
  cascade_delete             BOOLEAN      NOT NULL DEFAULT FALSE,
  created_at                 TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by                 TEXT         NOT NULL,
  updated_at                 TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by                 TEXT         NOT NULL,
  is_active                  BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.cardinality
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX cardinality_alt_key 
  ON pareto.cardinality(
    id_object,
    id_object_reference,
    id_rt_cardinality);

ALTER TABLE pareto.cardinality
  ADD CONSTRAINT cardinality_object
  FOREIGN KEY (id_object)
  REFERENCES pareto.object(id)
  ON DELETE CASCADE;

ALTER TABLE pareto.cardinality
  ADD CONSTRAINT cardinality_object_reference
  FOREIGN KEY (id_object_reference)
  REFERENCES pareto.object(id)
  ON DELETE CASCADE;

ALTER TABLE pareto.cardinality
  ADD CONSTRAINT cardinality_rt_cardinality
  FOREIGN KEY (id_rt_cardinality)
  REFERENCES pareto.ref_tables(id)
  ON DELETE CASCADE;

ALTER TABLE pareto.cardinality
  ADD CONSTRAINT cardinality_rt_cardinality_strength
  FOREIGN KEY (id_rt_cardinality_strength)
  REFERENCES pareto.ref_tables(id)
  ON DELETE SET NULL;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.cardinality
    FOR EACH ROW
      EXECUTE FUNCTION update_at();