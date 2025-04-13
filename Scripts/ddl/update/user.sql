-- ---------------------------------------------------------------------------------------
-- Update: pareto.user. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.u_user;
CREATE FUNCTION pareto.u_user(
  IN p_id UUID, 
  IN p_username VARCHAR, 
  IN p_email VARCHAR, 
  IN p_full_name VARCHAR, 
  IN p_updated_at TIMESTAMP, 
  IN p_updated_by VARCHAR
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'u_user';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pareto.pg_val;
  v_response     pareto.pg_resp;

  v_updates      INT;
  v_message      TEXT;
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
    'username', p_username, 
    'email', p_email, 
    'full_name', p_full_name, 
    'updated_at', p_updated_at, 
    'updated_by', p_updated_by
  );
  
  -- ------------------------------------------------------
  -- Validations
  -- ------------------------------------------------------
  
  v_val_resp := is_username('username', p_username);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('type', 'validation', 'field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;

  v_val_resp := is_email('email', p_email);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('type', 'validation', 'field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;

  v_val_resp := is_full_name('full_name', p_full_name);
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
    CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, p_updated_by, v_metadata);
    RETURN v_response;
  END IF;
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  UPDATE pareto.user SET
    username = p_username, 
    email = p_email, 
    full_name = p_full_name, 
    updated_by = p_updated_by, 
    updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id
      AND DATE_TRUNC('second', updated_at) = DATE_TRUNC('second', p_updated_at)
    RETURNING id, updated_at INTO v_id, v_updated_at;
  
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
    SELECT count(*) INTO v_count   
      FROM pareto.user 
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
