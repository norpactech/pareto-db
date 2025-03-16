-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE VIEW pareto.v_index AS
  SELECT o.name AS "object",
         i.name AS "index", 
         p.name AS "property",
         rt.name AS "sort_sequence"
  FROM pareto.index i
  JOIN pareto.data_object o     ON (o.id = i.id_data_object)
  JOIN pareto.index_property ip ON (ip.id_index = i.id)
  JOIN pareto.property p        ON (p.id = ip.id_property)
  JOIN pareto.ref_tables rt     ON (rt.id = ip.id_rt_sort_order);