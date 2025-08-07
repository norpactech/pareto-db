92c7de80-b53d-4347-af23-50a143a0276c
a7669f82-bc3f-41a8-820a-77e92b2e697d
a320f7b5-90bb-4fc3-95b6-e1274de0d234
null
13
created_at

true
false
19
0
false
CURRENT_TIMESTAMP
RDBMS Import Post

DROP FUNCTION IF EXISTS pareto.i_property;
CREATE FUNCTION pareto.i_property(
  IN p_id_data_object UUID, 
  IN p_id_generic_data_type UUID, 
  IN p_id_validation UUID, 
  IN p_id_generic_property_type UUID, 
  IN p_sequence INTEGER, 
  IN p_name VARCHAR, 
  IN p_description TEXT, 
  IN p_is_updatable BOOLEAN, 
  IN p_fk_viewable BOOLEAN, 
  IN p_length INTEGER, 
  IN p_scale INTEGER, 
  IN p_is_nullable BOOLEAN, 
  IN p_default_value TEXT, 
  IN p_created_by VARCHAR
)


SELECT pareto.i_property(
  '92c7de80-b53d-4347-af23-50a143a0276c',
  'a7669f82-bc3f-41a8-820a-77e92b2e697d',
  'a320f7b5-90bb-4fc3-95b6-e1274de0d234',
  null',
  13,
  'created_at',
  '',
  true,
  false,
  19,
  0,
  false,
  'CURRENT_TIMESTAMP',
  'RDBMS Import Post',
  ?)