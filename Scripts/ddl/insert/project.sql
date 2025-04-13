-- ---------------------------------------------------------------------------------------
-- Insert: pareto.project. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS pareto.i_project;
CREATE FUNCTION pareto.i_project(
  IN p_id_tenant UUID, 
  IN p_name VARCHAR, 
  IN p_description TEXT, 
  IN p_domain VARCHAR, 
  IN p_artifact VARCHAR, 
  IN p_created_by VARCHAR
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_project';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pareto.pg_val;  
  v_response     pareto.pg_resp;
  v_updated_at   TIMESTAMPTZ;
  
  -- Primary Key Field(s)
  v_id uuid := NULL;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_tenant', p_id_tenant, 
    'name', p_name, 
    'description', p_description, 
    'domain', p_domain, 
    'artifact', p_artifact, 
    'created_by', p_created_by
  );
  
  -- ------------------------------------------------------
  -- Validations
  -- ------------------------------------------------------
  
  v_val_resp := is_name('name', p_name);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('type', 'validation', 'field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;

  v_val_resp := is_package('domain', p_domain);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('type', 'validation', 'field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;

  v_val_resp := is_package('artifact', p_artifact);
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
 
  INSERT INTO pareto.project (
    id_tenant, 
    name, 
    description, 
    domain, 
    artifact, 
    created_by,
    updated_by
  )
  VALUES (
    p_id_tenant, 
    p_name, 
    p_description, 
    p_domain, 
    p_artifact, 
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
        'A record already exists in the project table', 
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
