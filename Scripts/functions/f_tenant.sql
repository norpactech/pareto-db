-- -------------------------------------------------------
-- Insert tenant
-- ------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.i_tenant(
  IN name TEXT, 
  IN description TEXT, 
  IN copyright TEXT, 
  IN created_by TEXT
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_tenant';

  v_val_resp     pg_val;
  v_errors       JSONB := '[]'::JSONB;
  v_response     pg_resp;
  v_metadata     JSONB := '{}'::JSONB;

  v_id           UUID;
  v_updated_at   TIMESTAMPTZ;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'name', name, 
    'description', description, 
    'copyright', copyright, 
    'created_by', created_by
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
    CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, created_by, v_metadata);
    RETURN v_response;
  END IF;
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  INSERT INTO pareto.tenant (
    name, 
    description, 
    copyright, 
    created_by,
    updated_by
  )
  VALUES (
    name, 
    description, 
    copyright, 
    created_by,
    created_by
  )
  RETURNING tenant.id, tenant.updated_at INTO v_id, v_updated_at;  

  v_response := (
    'OK', 
    jsonb_build_object('id', v_id, 'updated_at', v_updated_at), 
    NULL, NULL, NULL, NULL, NULL
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
        'A record already exists in the tenant table', 
        'Check the provided data and try again'
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, created_by, v_metadata);
  
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, created_by, v_metadata);

    RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;