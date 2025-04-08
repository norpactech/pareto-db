-- -------------------------------------------------------
-- Update context_property_type
--
-- Supports Optimistic Locking using Updated At
-- ------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.u_context_property_type(
  IN id uuid, 
  IN id_context uuid, 
  IN id_schema uuid, 
  IN id_generic_property_type uuid, 
  IN length Integer, 
  IN scale Integer, 
  IN is_nullable boolean, 
  IN default_value text, 
  IN updated_at timestamptz, 
  IN updated_by varchar
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'u_context_property_type';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pg_val;
  v_response     pg_resp;

  v_updates      INT;
  v_message      TEXT;
  v_count        INT;

  -- Set variables to avoid ambiguous column names
  v_id uuid := id;
  v_id_context uuid := id_context;
  v_id_schema uuid := id_schema;
  v_id_generic_property_type uuid := id_generic_property_type;
  v_length Integer := length;
  v_scale Integer := scale;
  v_is_nullable boolean := is_nullable;
  v_default_value text := default_value;
  v_updated_at timestamptz := updated_at;
  v_updated_by varchar := updated_by;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id', id, 
    'id_context', id_context, 
    'id_schema', id_schema, 
    'id_generic_property_type', id_generic_property_type, 
    'length', length, 
    'scale', scale, 
    'is_nullable', is_nullable, 
    'default_value', default_value, 
    'updated_at', updated_at, 
    'updated_by', updated_by
  );
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  UPDATE pareto.context_property_type SET
    id_context = v_id_context, 
    id_schema = v_id_schema, 
    id_generic_property_type = v_id_generic_property_type, 
    length = v_length, 
    scale = v_scale, 
    is_nullable = v_is_nullable, 
    default_value = v_default_value, 
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
      FROM pareto.context_property_type 
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
