-- ---------------------------------------------------------------------------------------
-- Insert: pareto.project_component. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS pareto.i_project_component;
CREATE FUNCTION pareto.i_project_component(
  IN id_project UUID, 
  IN id_context UUID, 
  IN id_plugin UUID, 
  IN name VARCHAR, 
  IN description TEXT, 
  IN sub_package VARCHAR, 
  IN created_by VARCHAR
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_project_component';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pareto.pg_val;  
  v_response     pareto.pg_resp;

  v_updated_at   TIMESTAMPTZ;

  -- Set the Property Variables
  v_id_context UUID := id_context;
  v_name VARCHAR := name;
  v_id UUID := NULL;
  v_created_by VARCHAR := created_by;
  v_id_plugin UUID := id_plugin;
  v_sub_package VARCHAR := sub_package;
  v_id_project UUID := id_project;
  v_description TEXT := description;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_project', id_project, 
    'id_context', id_context, 
    'id_plugin', id_plugin, 
    'name', name, 
    'description', description, 
    'sub_package', sub_package, 
    'created_by', created_by
  );
  
  -- ------------------------------------------------------
  -- Validations
  -- ------------------------------------------------------
  
  v_val_resp := is_name('name', name);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('type', 'validation', 'field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;

  v_val_resp := is_package('sub_package', sub_package);
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

  INSERT INTO pareto.project_component (
    id_project, 
    id_context, 
    id_plugin, 
    name, 
    description, 
    sub_package, 
    created_by,
    updated_by
  )
  VALUES (
    v_id_project, 
    v_id_context, 
    v_id_plugin, 
    v_name, 
    v_description, 
    v_sub_package, 
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
        jsonb_build_object('type', 'database', 'message', 'A UNIQUE constraint was violated due to duplicate data'), 
        '23514', 
        'A UNIQUE constraint was violated due to duplicate data', 
        'A record already exists in the project_component table', 
        'Check the provided data and try again'
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, v_created_by, v_metadata);
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, v_created_by, v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;
