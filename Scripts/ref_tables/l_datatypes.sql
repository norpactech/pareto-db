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

  v_seq               int   := 0;
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
  
  call pareto.i_ref_table_type(c_ref_table_type, 'Data Types', true, 'scott', v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  v_id_ref_table_type := v_response.id;

  -- -----------------------------------
  -- String Data
  -- -----------------------------------
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'varchar',  
    'Character Varying String', 
    'varchar', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;

  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'text',  
    'Unlimted String', 
    'text', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'char',  
    'Fixed Length String', 
    'char', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;

  -- -----------------------------------
  -- Numeric Data
  -- -----------------------------------
    
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'int',  
    'Integer', 
    'int', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'bigint',  
    'Big Integer', 
    'bigint', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'float',  
    'Single-Precision Floating-Point.', 
    'float', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'double',  
    'Double-Precision Floating-Point.', 
    'double', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;

  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'numeric',  
    'Precision for Financial and High-precision calculations. i.e. numeric(10,2)', 
    'numeric', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  -- -----------------------------------
  -- Date/Time Data
  -- -----------------------------------
    
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'timestamptz',  
    'Timestamp with Time Zone', 
    'timestamptz', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'timestamp',  
    'Timestamp without Time Zone', 
    'timestamp', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;

  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'date',  
    'Date without Time', 
    'date', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'time',  
    'Time without Timezone', 
    'time', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'timetz',  
    'Time with Timezone', 
    'timetz', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  -- -----------------------------------
  -- Various Data Types
  -- -----------------------------------
    
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'boolean',  
    'True/False', 
    'boolean', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'uuid',  
    'Unique Identifier', 
    'uuid', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;

  v_seq := v_seq + 1;
  call pareto.i_ref_tables(
    v_id_tenant, 
    v_id_ref_table_type, 
    'json',  
    'Unstructured JSON Data',
    'json', 
    v_seq, 
    'loader', 
    v_response);
  raise notice '%, %, %, %', v_response.success, v_response.id, v_response.updated, v_response.message;
  
end;
$$;

call pareto.l_ref_tables();
drop procedure if exists pareto.l_ref_tables;
