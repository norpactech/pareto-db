-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.index_property (
  id                    UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  id_index	            UUID         NOT NULL,
  id_property           UUID         NOT NULL,
  id_rt_sort_order      UUID         NOT NULL,
  sequence              INT          NOT NULL,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT         NOT NULL,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT         NOT NULL,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.index_property
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX index_property_alt_key 
  ON pareto.index_property(id_index, id_property);

ALTER TABLE pareto.index_property
  ADD CONSTRAINT index_property_index
  FOREIGN KEY (id_index)
  REFERENCES pareto.index(id)
  ON DELETE CASCADE;

ALTER TABLE pareto.index_property
  ADD CONSTRAINT index_property_property
  FOREIGN KEY (id_property)
  REFERENCES pareto.property(id)
  ON DELETE CASCADE;

ALTER TABLE pareto.index_property
  ADD CONSTRAINT index_property_rt_sort_order
  FOREIGN KEY (id_rt_sort_order)
  REFERENCES pareto.ref_tables(id)
  ON DELETE CASCADE;

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.index_property
    FOR EACH ROW
      EXECUTE FUNCTION update_at();