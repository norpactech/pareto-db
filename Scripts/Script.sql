select (select count(*) from pareto.data_object) as data_object_count,
       (select count(*) from pareto.property) as property_count,
       (select count(*) from pareto.data_index) as data_index_count,
       (select count(*) from pareto.data_index_property) as data_index_property_count,
       (select count(*) from pareto.cardinality) as cardinality_count;