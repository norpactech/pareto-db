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
  FROM pareto.index i
  JOIN pareto.data_object o     ON (o.id = i.id_data_object)
  JOIN pareto.index_property ip ON (ip.id_index = i.id)
  JOIN pareto.property p        ON (p.id = ip.id_property)
  JOIN pareto.ref_tables rt     ON (rt.id = ip.id_rt_sort_order);

-- List all tables and order by least to most dependent 	

DROP VIEW IF EXISTS pareto.v_table_dependencies;
CREATE VIEW pareto.v_table_dependencies AS
  -- has dependencies
  SELECT t.id     AS id_tenant,
         t.name   AS tenant_name,
		 s.id     AS id_schema,
         s.name   AS schema_name, 
		 o1.id    AS id_data_object,
         o1.name  AS data_object_name,
		 o2.id    AS id_object_dependency,
		 o2.name  AS object_dependency_name
    FROM pareto.data_object o1
    JOIN pareto.schema s ON (s.id = o1.id_schema) 
    JOIN pareto.tenant t ON (t.id = s.id_tenant)
    JOIN pareto.property p ON (p.id_data_object = o1.id)
    JOIN pareto.generic_property_type pt ON (pt.id = p.id_generic_property_type)
    JOIN pareto.cardinality c ON (c.id_property = p.id)
    JOIN pareto.data_object o2 ON (o2.id = c.id_object_reference)
   UNION
  -- No dependencies
  SELECT t.id     AS id_tenant,
         t.name   AS tenant_name,
		 s1.id    AS id_schema,
         s1.name  AS schema_name, 
		 o1.id    AS id_data_object,
         o1.name  AS data_object_name,
		 NULL     AS id_object_dependency,
		 NULL     AS object_dependency_name
    FROM pareto.data_object o1
    JOIN pareto.schema s1 ON (s1.id = o1.id_schema) 
    JOIN pareto.tenant t ON (t.id = s1.id_tenant)
   WHERE o1.id not in (SELECT o.id 
                         FROM pareto.data_object o
                         JOIN pareto.schema s2 ON (s2.id = o.id_schema) 
                         JOIN pareto.property p ON (p.id_data_object = o.id)
                         JOIN pareto.generic_property_type pt ON (pt.id = p.id_generic_property_type)
                         JOIN pareto.cardinality c ON (c.id_property = p.id)
                        WHERE s2.id = s1.id);
