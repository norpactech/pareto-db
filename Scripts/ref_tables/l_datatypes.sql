-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

drop procedure if exists pareto.l_ref_tables;
create procedure pareto.l_ref_tables()
language plpgsql
as $$
declare 

  c_tenant         constant varchar := 'system';
  c_ref_table_type constant varchar := 'datatype';

  v_seq               int;
  v_id_tenant         uuid;
  v_id_ref_table_type uuid;
  v_response          pareto.response;

begin
  
  -- -----------------------------------
  -- Get Tenant and Reference Table Type
  -- -----------------------------------
  
  select id into v_id_tenant
    from pareto.tenant 
   where name = c_tenant;
  assert v_id_tenant is not null, 'Load failed: tenant ' || c_tenant || ' not found.';
  
  select id into v_id_ref_table_type 
    from pareto.ref_table_type 
   where name = c_ref_table_type;
  assert v_id_ref_table_type is not null, 'Load failed: ref_table_type ' || c_ref_table_type || ' not found.';

  v_seq := 0;

  -- -----------------------------------
  -- String Data
  -- -----------------------------------
  
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'varchar',  
    'Character Varying String', 
    'varchar', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);
    
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'text',  
    'Unlimted String', 
    'text', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);
  
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'char',  
    'Fixed Length String', 
    'char', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);

  -- -----------------------------------
  -- Numeric Data
  -- -----------------------------------
    
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'int',  
    'Integer', 
    'int', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);
  
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'bigint',  
    'Big Integer', 
    'bigint', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);
  
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'float',  
    'Single-Precision Floating-Point.', 
    'float', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);
  
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'double',  
    'Double-Precision Floating-Point.', 
    'double', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);

  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'numeric',  
    'Precision for Financial and High-precision calculations. i.e. numeric(10,2)', 
    'numeric', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);
    
  -- -----------------------------------
  -- Various Data Types
  -- -----------------------------------
    
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'bool',  
    'True/False', 
    'bool', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);
  
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'uuid',  
    'Unique Identifier', 
    'uuid', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);

  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'json',  
    'Unstructured JSON Data',
    'json', 
    (set v_seq := v_seq + 1), 
    'system', 
    v_response);
  
end;
$$;

call pareto.l_ref_tables();
drop procedure if exists pareto.l_ref_tables;
