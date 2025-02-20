-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION pareto.i_tenant(
  IN in_id_tenant uuid, 
  IN in_customer_id text, 
  IN in_email text, 
  IN in_cell text, 
  IN in_description text, 
  IN in_created_by text
)
RETURNS pg_resp
AS $$
DECLARE

  v_val_resp   pg_val;
  v_errors     JSONB := '[]'::JSONB;
  v_response   pg_resp;

  v_id         uuid;
  v_updated_at timestamptz;
  v_updated_by text := in_created_by;

BEGIN

  -- ------------------------------------------------------
  -- Validations
  -- ------------------------------------------------------
  
  v_val_resp := is_email('email', in_email);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;
  
  v_val_resp := is_phone_number('cell', in_cell);
  IF NOT v_val_resp.passed THEN
    v_errors := v_errors || jsonb_build_object('field', v_val_resp.field, 'message', v_val_resp.message);
  END IF;
  
  IF jsonb_array_length(v_errors) > 0 THEN
    v_response := (
      'error', 
      NULL, 
      v_errors, 
      '23514', 
      'A CHECK constraint was violated due to incorrect input', 
      'Ensure all fields in the ''errors'' array are correctly formatted', 
      'The provided data did not pass validation checks'
    );
    RETURN v_response;
  END IF;
  
  -- ------------------------------------------------------
  -- Persist
  -- ------------------------------------------------------

  INSERT INTO target.customer (
    id_tenant, 
    customer_id, 
    email, 
    cell, 
    description, 
    created_by, 
    updated_by
  )
  VALUES (
    in_id_tenant, 
    in_customer_id, 
    in_email, 
    in_cell, 
    in_description, 
    in_created_by, 
    v_updated_by
  )
  RETURNING tenant.id, tenant.updated_at INTO v_id, v_updated_at;  

  v_response := (
    'success', 
    jsonb_build_object('id', v_id, 'updated_at', v_updated_at), 
    NULL, NULL, NULL, NULL, NULL
  );
  RETURN v_response;

  -- ------------------------------------------------------
  -- Exceptions
  -- ------------------------------------------------------
  
  EXCEPTION
    WHEN OTHERS THEN
      v_response := (
        'error', 
        NULL, 
        NULL, 
        SQLSTATE, 
        'An unexpected error occurred', 
        'Check database logs for more details', 
        SQLERRM
      );
    RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;