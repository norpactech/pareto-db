-- ---------------------------------------------------------------------------------------
-- Insert: pareto.ref_tables. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.i_ref_tables(
  IN id_ref_table_type uuid, 
  IN name varchar, 
  IN description text, 
  IN value text, 
  IN sequence Integer, 
  IN created_by varchar
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_ref_tables';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pg_val;
  v_response     pg_resp;

  v_id           UUID;
  v_updated_at   TIMESTAMPTZ;

  -- Set variables to avoid ambiguous column names
  v_id_ref_table_type uuid := id_ref_table_type;
  v_name varchar := name;
  v_description text := description;
  v_value text := value;
  v_sequence Integer := sequence;
  v_created_by varchar := created_by;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_ref_table_type', id_ref_table_type, 
    'name', name, 
    'description', description, 
    'value', value, 
    'sequence', sequence, 
    'created_by', created_by
  );
  
  -- ------------------------------------------------------
  -- Validations
  -- ------------------------------------------------------
  
  v_val_resp := is_name('name', name);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('type', 'validation', 'field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;

  IF jsonb_array_length(v_errors) > 0 THEN
    v_response := (
      'ERROR', 
      NULL, 
      v_errors, 
      '23514', 
      'A CHECK constraint was violated due to incorrect input', 
      'Ensure all fields in the ''errors'' array are correctly formatted', 
      'The provided data did not pass validation checks'
    );
    CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, created_by, v_metadata);
    RETURN v_response;
  END IF;
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  INSERT INTO pareto.ref_tables (
    id_ref_table_type, 
    name, 
    description, 
    value, 
    sequence, 
    created_by,
    updated_by
  )
  VALUES (
    v_id_ref_table_type, 
    v_name, 
    v_description, 
    v_value, 
    v_sequence, 
    v_created_by,
    v_created_by
  )
  RETURNING id, updated_at INTO v_id, v_updated_at;  

  v_response := (
    'OK', 
    jsonb_build_object('id', v_id, 'updated_at', v_updated_at), 
    NULL, 
    '00000',
    'Insert was successful', 
    NULL, 
    NULL
  );
  RETURN v_response;

  -- ------------------------------------------------------
  -- Exceptions
  -- ------------------------------------------------------
  
  EXCEPTION
    WHEN UNIQUE_VIOLATION THEN
      v_response := (
        'ERROR', 
        NULL, 
        NULL, 
        '23514', 
        'A UNIQUE constraint was violated due to duplicate data', 
        'A record already exists in the ref_tables table', 
        'Check the provided data and try again'
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, created_by, v_metadata);
      RETURN v_response;
  
    WHEN OTHERS THEN
      v_response := (
        'ERROR', 
        NULL, 
        NULL, 
        SQLSTATE, 
        'An unexpected error occurred', 
        'Check database logs for more details', 
        SQLERRM
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, created_by, v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;
