-- -------------------------------------------------------
-- Deactivate generic_data_type_attribute (Soft Delete)
-- ------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.deact_generic_data_type_attribute;
CREATE FUNCTION pareto.deact_generic_data_type_attribute (
  IN p_id UUID, 
  IN p_updated_at TIMESTAMP, 
  IN p_updated_by VARCHAR
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'deact_generic_data_type_attribute';

  v_metadata     JSONB := '{}'::JSONB;
  v_response     pareto.pg_resp;
  v_message      TEXT;
  v_updates      INT;
  v_count        INT;
  v_updated_at   TIMESTAMP := p_updated_at;

  -- Primary Key Field(s)
  v_id uuid := p_id;
  
BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id', p_id, 
    'updated_at', p_updated_at, 
    'updated_by', p_updated_by
  );
  
  -- ------------------------------------------------------
  -- Deactivate generic_data_type_attribute
  -- ------------------------------------------------------

 UPDATE pareto.generic_data_type_attribute
    SET is_active = false 
    WHERE id = v_id
      AND DATE_TRUNC('second', updated_at) = DATE_TRUNC('second', p_updated_at)
    RETURNING id, updated_at INTO v_id, v_updated_at;

  GET DIAGNOSTICS v_updates = ROW_COUNT;

  IF v_updates > 0 THEN
    v_response := (
      'OK', 
      jsonb_build_object('id', v_id, 'updated_at', v_updated_at), 
      NULL, 
      '00000',
      'Deactivate was successful', 
      NULL, 
      NULL
    );
    CALL pareto.i_logs('INFO', v_response.message, c_service_name, p_updated_by, v_metadata);    
  ELSE
    -- Check for Optimistic Lock Error
    SELECT count(*) INTO v_count   
      FROM pareto.generic_data_type_attribute 
    WHERE id = v_id;
          
    IF (v_count > 0) THEN
      -- Record does exists but the updated_at timestamp has changed
      -- The id and updated_at values are not returned. The client must refresh the record.      
      v_message := 'The record was updated by another transaction. Refresh and try again';
      v_response := (
        'ERROR', 
        NULL, 
        jsonb_build_object('type', 'optimistic_lock', 'field', 'updated_at', 'message', v_message), 
        '00002',
        'No records were found matching the query.',
        'The UPDATED_AT query parameter does not match the current record.',
        'Obtain the latest updated_at timestamp and try again.'          
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_updated_by, v_metadata);
      RETURN v_response;
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_updated_by, v_metadata);
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_updated_by, v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;

-- -------------------------------------------------------
-- Reactivate generic_data_type_attribute (Soft Undelete)
-- ------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.react_generic_data_type_attribute;
CREATE FUNCTION pareto.react_generic_data_type_attribute (
  IN p_id UUID, 
  IN p_updated_at TIMESTAMP, 
  IN p_updated_by VARCHAR
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'react_generic_data_type_attribute';

  v_metadata     JSONB := '{}'::JSONB;
  v_response     pareto.pg_resp;
  v_message      TEXT;
  v_updates      INT;
  v_count        INT;
  v_updated_at   TIMESTAMP := p_updated_at;

  -- Primary Key Field(s)
  v_id uuid := p_id;
  
BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id', p_id, 
    'updated_at', p_updated_at, 
    'updated_by', p_updated_by
  );
  
  -- ------------------------------------------------------
  -- Deactivate generic_data_type_attribute
  -- ------------------------------------------------------

 UPDATE pareto.generic_data_type_attribute
    SET is_active = TRUE 
    WHERE id = v_id
      AND DATE_TRUNC('second', updated_at) = DATE_TRUNC('second', p_updated_at)
    RETURNING id, updated_at INTO v_id, v_updated_at;

  GET DIAGNOSTICS v_updates = ROW_COUNT;

  IF v_updates > 0 THEN
    v_response := (
      'OK', 
      jsonb_build_object('id', v_id, 'updated_at', v_updated_at), 
      NULL, 
      '00000',
      'Reactivate was successful', 
      NULL, 
      NULL
    );
    CALL pareto.i_logs('INFO', v_response.message, c_service_name, p_updated_by, v_metadata);    
  ELSE
    -- Check for Optimistic Lock Error
    SELECT count(*) INTO v_count   
      FROM pareto.generic_data_type_attribute 
    WHERE id = v_id;
          
    IF (v_count > 0) THEN
      -- Record does exists but the updated_at timestamp has changed
      -- The id and updated_at values are not returned. The client must refresh the record.      
      v_message := 'The record was updated by another transaction. Refresh and try again';
      v_response := (
        'ERROR', 
        NULL, 
        jsonb_build_object('type', 'optimistic_lock', 'field', 'updated_at', 'message', v_message), 
        '00002',
        'No records were found matching the query.',
        'The UPDATED_AT query parameter does not match the current record.',
        'Obtain the latest updated_at timestamp and try again.'          
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_updated_by, v_metadata);
      RETURN v_response;
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_updated_by, v_metadata);
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_updated_by, v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;