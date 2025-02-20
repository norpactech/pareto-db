-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

DO $$ 
DECLARE

BEGIN

  INSERT INTO pareto.tenant (name, description, copyright, created_by, updated_by)
    VALUES ('system', 'Global System Tenant', 'Northern Pacific Technologies', 'loader', 'loader');

  INSERT INTO pareto.tenant (name, description, copyright, created_by, updated_by)
    VALUES ('norpac', 'Northern Pacific Technogies', 'Northern Pacific Technologies', 'loader', 'loader');
  
END $$;
