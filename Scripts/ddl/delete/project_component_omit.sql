-- -------------------------------------------------------
-- Delete project_component_omit
-- ------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.d_project_component_omit;
CREATE FUNCTION pareto.d_project_component_omit(
  IN p_id_project_component UUID, 
  IN p_id_data_object UUID
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'd_project_component_omit';

  v_metadata     JSONB := '{}'::JSONB;
  v_response     pareto.pg_resp;
  v_message      TEXT;  
  v_updates      INT;
  v_count        INT;

  -- Primary Key Field(s)
  v_id_project_component uuid := p_id_project_component;
  v_id_data_object uuid := p_id_data_object;
    
BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_project_component', p_id_project_component, 
    'id_data_object', p_id_data_object
  );
  
  -- ------------------------------------------------------
  -- Delete
  -- ------------------------------------------------------

  DELETE FROM pareto.project_component_omit 
    WHERE id_project_component = v_id_project_component
      AND id_data_object = v_id_data_object
  ;
  GET DIAGNOSTICS v_updates = ROW_COUNT;

  IF v_updates > 0 THEN
    -- Record was deleted
    v_response := (
      'OK', 
      jsonb_build_object('id_project_component', v_id_project_component, 'id_data_object', v_id_data_object), 
      NULL, 
      '00000',
      'Delete was successful', 
      NULL, 
      NULL
    );
    CALL pareto.i_logs('INFO', v_response.message, c_service_name, 'unknown', v_metadata);    
  ELSE  
      -- Record does not exist
      v_response := (
        'ERROR', 
        NULL, 
        NULL, 
        '00002',
        'No records were found matching the query.',
        'Check the query parameters or ensure data exists.',
        'The requested resource does not exist in the database.'          
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, 'unknown', v_metadata);
  END IF;    

  RETURN v_response;
 
  -- ------------------------------------------------------
  -- Exceptions
  -- ------------------------------------------------------
  
  EXCEPTION
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, 'unknown', v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;

