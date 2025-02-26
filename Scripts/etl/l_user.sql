-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

DO $$ 
DECLARE

BEGIN

  INSERT INTO pareto.user (username, email, full_name, created_by, updated_by)
    VALUES ('system', 'system@email.com', 'Northern Pacific Technologies', 'loader', 'loader');

  INSERT INTO pareto.user (username, email, full_name, created_by, updated_by)
    VALUES ('user', 'user@email.com', 'Test User', 'loader', 'loader');
  
END;
$$;