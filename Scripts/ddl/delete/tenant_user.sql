-- -------------------------------------------------------
-- Delete tenant_user
-- ------------------------------------------------------
DROP FUNCTION IF EXISTS pareto.d_tenant_user;
CREATE FUNCTION pareto.d_tenant_user(
  IN p_id_tenant UUID, 
  IN p_id_user UUID
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'd_tenant_user';

  v_metadata     JSONB := '{}'::JSONB;
  v_response     pareto.pg_resp;
  v_message      TEXT;  
  v_updates      INT;
  v_count        INT;

  -- Primary Key Field(s)
  v_id_tenant uuid := p_id_tenant;
  v_id_user uuid := p_id_user;
    
BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_tenant', p_id_tenant, 
    'id_user', p_id_user
  );
  
  -- ------------------------------------------------------
  -- Delete
  -- ------------------------------------------------------

  DELETE FROM pareto.tenant_user 
    WHERE id_tenant = v_id_tenant
      AND id_user = v_id_user
  ;
  GET DIAGNOSTICS v_updates = ROW_COUNT;

  IF v_updates > 0 THEN
    -- Record was deleted
    v_response := (
      'OK', 
      jsonb_build_object('id_tenant', v_id_tenant, 'id_user', v_id_user), 
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

