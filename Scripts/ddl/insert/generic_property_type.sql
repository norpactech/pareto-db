-- ---------------------------------------------------------------------------------------
-- Insert: pareto.generic_property_type. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS pareto.i_generic_property_type;
CREATE FUNCTION pareto.i_generic_property_type(
  IN p_id_generic_data_type UUID, 
  IN p_id_validation UUID, 
  IN p_name VARCHAR, 
  IN p_description TEXT, 
  IN p_length INTEGER, 
  IN p_scale INTEGER, 
  IN p_is_nullable BOOLEAN, 
  IN p_default_value TEXT, 
  IN p_created_by VARCHAR
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_generic_property_type';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pareto.pg_val;  
  v_response     pareto.pg_resp;
  v_updated_at   TIMESTAMP;
  
  -- Primary Key Field(s)
  v_id uuid := NULL;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_generic_data_type', p_id_generic_data_type, 
    'id_validation', p_id_validation, 
    'name', p_name, 
    'description', p_description, 
    'length', p_length, 
    'scale', p_scale, 
    'is_nullable', p_is_nullable, 
    'default_value', p_default_value, 
    'created_by', p_created_by
  );
  
  -- ------------------------------------------------------
  -- Validations
  -- ------------------------------------------------------
  
  v_val_resp := is_name('name', p_name);
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
    CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_created_by, v_metadata);
    RETURN v_response;
  END IF;
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------
 
  INSERT INTO pareto.generic_property_type (
    id_generic_data_type, 
    id_validation, 
    name, 
    description, 
    length, 
    scale, 
    is_nullable, 
    default_value, 
    created_by,
    updated_by
  )
  VALUES (
    p_id_generic_data_type, 
    p_id_validation, 
    p_name, 
    p_description, 
    p_length, 
    p_scale, 
    p_is_nullable, 
    p_default_value, 
    p_created_by,
    p_created_by
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
        jsonb_build_object('type', 'database', 'message', 'A UNIQUE constraint was violated due to duplicate data'), 
        '23514', 
        'A UNIQUE constraint was violated due to duplicate data', 
        'A record already exists in the generic_property_type table', 
        'Check the provided data and try again'
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_created_by, v_metadata);
      RETURN v_response;
  
    WHEN OTHERS THEN
      v_response := (
        'ERROR', 
        NULL, 
        jsonb_build_object('type', 'database', 'message', SQLERRM), 
        SQLSTATE, 
        'An unexpected error occurred', 
        'Check database logs for more details', 
        SQLERRM
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_created_by, v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;
