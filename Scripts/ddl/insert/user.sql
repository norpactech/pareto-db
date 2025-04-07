-- ---------------------------------------------------------------------------------------
-- Insert: pareto.user. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.i_user(
  IN id uuid, 
  IN username varchar, 
  IN email varchar, 
  IN full_name varchar, 
  IN created_at timestamptz, 
  IN created_by varchar, 
  IN updated_at timestamptz, 
  IN updated_by varchar, 
  IN is_active boolean
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_user';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pg_val;
  v_response     pg_resp;

  v_id           UUID;
  v_updated_at   TIMESTAMPTZ;

  -- Set variables to avoid ambiguous column names
  v_id uuid := id;
  v_username varchar := username;
  v_email varchar := email;
  v_full_name varchar := full_name;
  v_created_at timestamptz := created_at;
  v_created_by varchar := created_by;
  v_updated_at timestamptz := updated_at;
  v_updated_by varchar := updated_by;
  v_is_active boolean := is_active;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id', id, 
    'username', username, 
    'email', email, 
    'full_name', full_name, 
    'created_at', created_at, 
    'created_by', created_by, 
    'updated_at', updated_at, 
    'updated_by', updated_by, 
    'is_active', is_active
  );
  
  -- ------------------------------------------------------
  -- Validations
  -- ------------------------------------------------------
  
  v_val_resp := is_username('username', username);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('type', 'validation', 'field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;

  v_val_resp := is_email('email', email);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('type', 'validation', 'field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;

  v_val_resp := is_full_name('full_name', full_name);
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

  INSERT INTO pareto.user (
    id, 
    username, 
    email, 
    full_name, 
    created_at, 
    updated_at, 
    updated_by, 
    is_active, 
    created_by,
    updated_by
  )
  VALUES (
    v_id, 
    v_username, 
    v_email, 
    v_full_name, 
    v_created_at, 
    v_updated_at, 
    v_updated_by, 
    v_is_active, 
    v_created_by,
    v_created_by
  )
  RETURNING user.id, user.updated_at INTO v_id, v_updated_at;  

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
        NULL, 
        '23514', 
        'A UNIQUE constraint was violated due to duplicate data', 
        'A record already exists in the user table', 
        'Check the provided data and try again'
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, created_by, v_metadata);
      RETURN v_response;
  
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
