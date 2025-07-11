-- ---------------------------------------------------------------------------------------
-- Insert: pareto.tenant_user. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS pareto.i_tenant_user;
CREATE FUNCTION pareto.i_tenant_user(
  IN p_id_tenant UUID, 
  IN p_id_user UUID
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_tenant_user';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pareto.pg_val;  
  v_response     pareto.pg_resp;
  
  -- Primary Key Field(s)
  v_id_tenant uuid := NULL;
  v_id_user uuid := NULL;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_tenant', p_id_tenant, 
    'id_user', p_id_user
  );
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------
 
  INSERT INTO pareto.tenant_user (
    id_tenant, 
    id_user
  )
  VALUES (
    p_id_tenant, 
    p_id_user
  )
  RETURNING id_tenant, id_user INTO v_id_tenant, v_id_user;

  v_response := (
    'OK',
    jsonb_build_object('id_tenant', v_id_tenant, 'id_user', v_id_user), 
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
        'A record already exists in the tenant_user table', 
        'Check the provided data and try again'
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, 'unknown', v_metadata);
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, 'unknown', v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;
