-- ---------------------------------------------------------------------------------------
-- Insert: pareto.generic_data_type. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.i_generic_data_type(
  IN id_tenant UUID, 
  IN sequence INTEGER, 
  IN name VARCHAR, 
  IN description TEXT, 
  IN alias TEXT, 
  IN created_by VARCHAR
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_generic_data_type';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pareto.pg_val;  
  v_response     pareto.pg_resp;

  v_updated_at   TIMESTAMPTZ;

  -- Set the Property Variables
  v_name VARCHAR := name;
  v_id UUID := NULL;
  v_created_by VARCHAR := created_by;
  v_sequence INTEGER := sequence;
  v_description TEXT := description;
  v_id_tenant UUID := id_tenant;
  v_alias TEXT := alias;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_tenant', id_tenant, 
    'sequence', sequence, 
    'name', name, 
    'description', description, 
    'alias', alias, 
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
    CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, v_created_by, v_metadata);
    RETURN v_response;
  END IF;
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  INSERT INTO pareto.generic_data_type (
    id_tenant, 
    sequence, 
    name, 
    description, 
    alias, 
    created_by,
    updated_by
  )
  VALUES (
    v_id_tenant, 
    v_sequence, 
    v_name, 
    v_description, 
    v_alias, 
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
        'A record already exists in the generic_data_type table', 
        'Check the provided data and try again'
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, v_created_by, v_metadata);
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, v_created_by, v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;
