-- -------------------------------------------------------
-- Update ref_tables
--
-- Supports Optimistic Locking using Updated At
-- ------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.u_ref_tables(
  IN id uuid, 
  IN id_ref_table_type uuid, 
  IN name varchar, 
  IN description text, 
  IN value text, 
  IN sequence Integer, 
  IN updated_at timestamptz, 
  IN updated_by varchar
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'u_ref_tables';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pg_val;
  v_response     pg_resp;

  v_updates      INT;
  v_message      TEXT;
  v_count        INT;

  -- Set variables to avoid ambiguous column names
  v_id uuid := id;
  v_id_ref_table_type uuid := id_ref_table_type;
  v_name varchar := name;
  v_description text := description;
  v_value text := value;
  v_sequence Integer := sequence;
  v_updated_at timestamptz := updated_at;
  v_updated_by varchar := updated_by;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id', id, 
    'id_ref_table_type', id_ref_table_type, 
    'name', name, 
    'description', description, 
    'value', value, 
    'sequence', sequence, 
    'updated_at', updated_at, 
    'updated_by', updated_by
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
    CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, updated_by, v_metadata);
    RETURN v_response;
  END IF;
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  UPDATE pareto.ref_tables SET
    id_ref_table_type = v_id_ref_table_type, 
    name = v_name, 
    description = v_description, 
    value = v_value, 
    sequence = v_sequence, 
    updated_by = v_updated_by, 
    updated_at = CURRENT_TIMESTAMP
    WHERE id = v_id
      AND updated_at = v_updated_at
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
    v_id := id;
    SELECT count(*) INTO v_count   
      FROM pareto.ref_tables 
     WHERE id = v_id;
          
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
