-- -------------------------------------------------------
-- Update project_component_property
--
-- Supports Optimistic Locking using Updated At
-- ------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.u_project_component_property(
  IN id uuid, 
  IN id_project_component uuid, 
  IN sequence Integer, 
  IN data_object_filter text, 
  IN property_filter text, 
  IN updated_by varchar
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'u_project_component_property';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pg_val;
  v_response     pg_resp;

  v_updates      INT;
  v_message      TEXT;
  v_count        INT;

  -- Set variables to avoid ambiguous column names
  v_id uuid := id;
  v_id_project_component uuid := id_project_component;
  v_sequence Integer := sequence;
  v_data_object_filter text := data_object_filter;
  v_property_filter text := property_filter;
  v_updated_by varchar := updated_by;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id', id, 
    'id_project_component', id_project_component, 
    'sequence', sequence, 
    'data_object_filter', data_object_filter, 
    'property_filter', property_filter, 
    'updated_by', updated_by
  );
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  UPDATE pareto.project_component_property SET
    id_project_component = v_id_project_component, 
    sequence = v_sequence, 
    data_object_filter = v_data_object_filter, 
    property_filter = v_property_filter, 
    updated_by = v_updated_by, 
    updated_at = CURRENT_TIMESTAMP
  WHERE project_component_property.id = v_id
    AND project_component_property.updated_at = v_updated_at
  RETURNING project_component_property.id, project_component_property.updated_at INTO v_id, v_updated_at;

  GET DIAGNOSTICS v_updates = ROW_COUNT;

  IF v_updates > 0 THEN
    -- Record was updated
    v_response := (
      'OK', 
      jsonb_build_object('id', v_id, 'updated_at', v_updated_at), 
      NULL, 
      '00000',
      'Update was successful', 
      NULL, 
      NULL
  );    
  ELSE  
    -- Check for Optimistic Lock Error
    v_id := id;
    SELECT count(*) INTO v_count   
      FROM pareto.project_component_property 
     WHERE project_component_property.id = v_id;
          
    IF (v_count > 0) THEN
      -- Record does exists but the updated_at timestamp has changed
      -- The id and updated_at values are not returned. The client must refresh the record.      
      v_message := 'The record was updated by another transaction. Refresh and try again';
      v_response := (
        'ERROR', 
        NULL, 
        jsonb_build_object('type', 'optimistic_lock', 'field', 'updated_at', 'message', v_message), 
        'P0002',
        'No records were found matching the query.',
        'The UPDATED_AT query parameter does not match the current record.',
        'Obtain the latest updated_at timestamp and try again.'          
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, updated_by, v_metadata);
      RETURN v_response;
    ELSE
      -- Record does not exist
      v_response := (
        'ERROR', 
        NULL, 
        NULL, 
        'P0002',
        'No records were found matching the query.',
        'Check the query parameters or ensure data exists.',
        'The requested resource does not exist in the database.'          
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, updated_by, v_metadata);
    END IF;
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, updated_by, v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;
