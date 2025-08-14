-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

DROP VIEW IF EXISTS pareto.v_index;
CREATE VIEW pareto.v_index AS
  SELECT o.name AS "object",
         i.name AS "index", 
         p.name AS "property",
         rt.name AS "sort_sequence"
  FROM pareto.data_index i
  JOIN pareto.data_object o          ON (o.id = i.id_data_object)
  JOIN pareto.data_index_property ip ON (ip.id_data_index = i.id)
  JOIN pareto.property p             ON (p.id = ip.id_property)
  JOIN pareto.ref_tables rt          ON (rt.id = ip.id_rt_sort_order);

DROP VIEW IF EXISTS pareto.v_object_dependencies CASCADE;
CREATE VIEW pareto.v_object_dependencies AS
SELECT 
  t.id AS id_tenant,
  t.name AS tenant_name,
  s.id AS id_schema, 
  s.name AS schema_name,
  do1.id AS id_child_object,
  do1.name AS child_object_name,
  p.name AS property_name,
  do2.id AS id_parent_object,
  do2.name AS parent_object_name
FROM pareto.property p
JOIN pareto.data_object do1 ON (do1.id = p.id_data_object)
JOIN pareto.cardinality c ON (c.id_property = p.id)
JOIN pareto.data_object do2 ON (do2.id = c.id_data_object)
JOIN pareto.schema s ON (s.id = do1.id_schema)
JOIN pareto.tenant t ON (t.id = s.id_tenant);