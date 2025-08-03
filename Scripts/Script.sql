SELECT pareto.cardinality.*, 
pareto.property.name as property_name, 
pareto.data_object.name as data_object_name 
FROM pareto.cardinality 
  JOIN pareto.property on (pareto.property.id = pareto.cardinality.id_property) 
  JOIN pareto.data_object on (pareto.data_object.id = pareto.cardinality.id_data_object)
 where pareto.cardinality.id_data_object = '30cc9acd-1455-4ed4-adbe-9e45f63683e4'
   and pareto.cardinality.id_property = 'ff32285a-ecc6-4c1a-8c4c-e8e4102fa2e6'