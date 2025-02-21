-- -------------------------------------------------------
-- Update tenant
--
-- Supports Optimistic Locking using Updated At
-- ------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.u_tenant(
  IN id UUID, 
  IN name TEXT, 
  IN description TEXT, 
  IN copyright TEXT, 
  IN updated_at TIMESTAMPTZ, 
  IN updated_by TEXT
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'u_tenant';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pg_val;
  v_response     pg_resp;

  v_updates      INT;
  v_message      TEXT;
  v_count        INT;

  -- Set variables to avoid ambiguous column names
  v_id UUID := id;
  v_name TEXT := name;
  v_description TEXT := description;
  v_copyright TEXT := copyright;
  v_updated_at TIMESTAMPTZ := updated_at;
  v_updated_by TEXT := updated_by;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id', id, 
    'name', name, 
    'description', description, 
    'copyright', copyright, 
    'updated_at', updated_at, 
    'updated_by', updated_by
  );
  
  -- ------------------------------------------------------
  -- Validations
  -- ------------------------------------------------------
  
  v_val_resp := is_generic_name('name', name);
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

  UPDATE pareto.tenant SET
    name = v_name, 
    description = v_description, 
    copyright = v_copyright, 
    updated_by = v_updated_by, 
    updated_at = CURRENT_TIMESTAMP
  WHERE tenant.id = v_id
    AND tenant.updated_at = v_updated_at
  RETURNING tenant.id, tenant.updated_at INTO v_id, v_updated_at;

  GET DIAGNOSTICS v_updates = ROW_COUNT;

  IF v_updates > 0 THEN
    -- Record was updated
    v_response := (
      'OK', 
      jsonb_build_object('id', v_id, 'updated_at', v_updated_at), 
      NULL, NULL, NULL, NULL, NULL
    );
  ELSE  
    -- Check for Optimistic Lock Error
    v_id := id;
    SELECT count(*) INTO v_count   
      FROM pareto.tenant 
     WHERE tenant.id = v_id;
          
    IF (v_count > 0) THEN
      -- Record does exists but the updated_at timestamp has changed      
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
