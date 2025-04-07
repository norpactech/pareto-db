-- ---------------------------------------------------------------------------------------
-- Insert: pareto.generic_property_type. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pareto.i_generic_property_type(
  IN id uuid, 
  IN id_generic_data_type uuid, 
  IN id_tenant uuid, 
  IN id_validation uuid, 
  IN name varchar, 
  IN description text, 
  IN length Integer, 
  IN precision Integer, 
  IN is_nullable boolean, 
  IN default_value text, 
  IN created_at timestamptz, 
  IN created_by varchar, 
  IN updated_at timestamptz, 
  IN updated_by varchar, 
  IN is_active boolean
)
RETURNS pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'i_generic_property_type';

  v_metadata     JSONB := '{}'::JSONB;
  v_errors       JSONB := '[]'::JSONB;
  v_val_resp     pg_val;
  v_response     pg_resp;

  v_id           UUID;
  v_updated_at   TIMESTAMPTZ;

  -- Set variables to avoid ambiguous column names
  v_id uuid := id;
  v_id_generic_data_type uuid := id_generic_data_type;
  v_id_tenant uuid := id_tenant;
  v_id_validation uuid := id_validation;
  v_name varchar := name;
  v_description text := description;
  v_length Integer := length;
  v_precision Integer := precision;
  v_is_nullable boolean := is_nullable;
  v_default_value text := default_value;
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
    'id_generic_data_type', id_generic_data_type, 
    'id_tenant', id_tenant, 
    'id_validation', id_validation, 
    'name', name, 
    'description', description, 
    'length', length, 
    'precision', precision, 
    'is_nullable', is_nullable, 
    'default_value', default_value, 
    'created_at', created_at, 
    'created_by', created_by, 
    'updated_at', updated_at, 
    'updated_by', updated_by, 
    'is_active', is_active
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
    CALL pareto.i_logs(v_response.status, v_response.message, c_service_name, created_by, v_metadata);
    RETURN v_response;
  END IF;
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  INSERT INTO pareto.generic_property_type (
    id, 
    id_generic_data_type, 
    id_tenant, 
    id_validation, 
    name, 
    description, 
    length, 
    precision, 
    is_nullable, 
    default_value, 
    created_at, 
    updated_at, 
    updated_by, 
    is_active, 
    created_by,
    updated_by
  )
  VALUES (
    v_id, 
    v_id_generic_data_type, 
    v_id_tenant, 
    v_id_validation, 
    v_name, 
    v_description, 
    v_length, 
    v_precision, 
    v_is_nullable, 
    v_default_value, 
    v_created_at, 
    v_updated_at, 
    v_updated_by, 
    v_is_active, 
    v_created_by,
    v_created_by
  )
  RETURNING generic_property_type.id, generic_property_type.updated_at INTO v_id, v_updated_at;  

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
        'A record already exists in the generic_property_type table', 
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
