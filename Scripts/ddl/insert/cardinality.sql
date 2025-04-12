-- ---------------------------------------------------------------------------------------
-- Insert: pareto.cardinality. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS pareto.i_cardinality;
CREATE FUNCTION pareto.i_cardinality(
  IN id_property UUID, 
  IN id_object_reference UUID, 
  IN id_rt_cardinality UUID, 
  IN id_rt_cardinality_strength UUID, 
  IN has_referencial_action BOOLEAN, 
  IN created_by VARCHAR
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_cardinality';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pareto.pg_val;  
  v_response     pareto.pg_resp;

  v_updated_at   TIMESTAMPTZ;

  -- Set the Property Variables
  v_id UUID := NULL;
  v_has_referencial_action BOOLEAN := has_referencial_action;
  v_created_by VARCHAR := created_by;
  v_id_object_reference UUID := id_object_reference;
  v_id_rt_cardinality UUID := id_rt_cardinality;
  v_id_rt_cardinality_strength UUID := id_rt_cardinality_strength;
  v_id_property UUID := id_property;

BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_property', id_property, 
    'id_object_reference', id_object_reference, 
    'id_rt_cardinality', id_rt_cardinality, 
    'id_rt_cardinality_strength', id_rt_cardinality_strength, 
    'has_referencial_action', has_referencial_action, 
    'created_by', created_by
  );
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  INSERT INTO pareto.cardinality (
    id_property, 
    id_object_reference, 
    id_rt_cardinality, 
    id_rt_cardinality_strength, 
    has_referencial_action, 
    created_by,
    updated_by
  )
  VALUES (
    v_id_property, 
    v_id_object_reference, 
    v_id_rt_cardinality, 
    v_id_rt_cardinality_strength, 
    v_has_referencial_action, 
    v_created_by,
    v_created_by
  )
  RETURNING id, updated_at INTO v_id, v_updated_at;

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
        jsonb_build_object('type', 'database', 'message', 'A UNIQUE constraint was violated due to duplicate data'), 
        '23514', 
        'A UNIQUE constraint was violated due to duplicate data', 
        'A record already exists in the cardinality table', 
        'Check the provided data and try again'
      );
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, v_created_by, v_metadata);
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
      CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, v_created_by, v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;
