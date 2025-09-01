-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

-- Child tables (use foreign key relationships for tenant isolation)
-- CREATE POLICY tenant_isolation_policy ON pareto.project
--  FOR ALL TO web_update
--  USING (id_schema IN (
--    SELECT id FROM pareto.schema 
--    WHERE id_tenant = current_setting('app.current_tenant')::uuid
--  ));

-- Grandchild tables (use chained foreign key relationships for tenant isolation)
-- CREATE POLICY tenant_isolation_policy ON pareto.project_component
--  FOR ALL TO web_update
--  USING (id_project IN (
--    SELECT p.id FROM pareto.project p
--    JOIN pareto.schema s ON p.id_schema = s.id
--    WHERE s.id_tenant = current_setting('app.current_tenant')::uuid
--  ));

-- Enable RLS on all tenant tables
ALTER TABLE pareto.tenant ENABLE ROW LEVEL SECURITY;

-- Drop policy if it exists, then create it
DROP POLICY IF EXISTS tenant_isolation_policy ON pareto.tenant;
CREATE POLICY tenant_isolation_policy ON pareto.tenant
  FOR ALL TO web_update
  USING (id = current_setting('app.current_tenant')::uuid);

ALTER TABLE pareto.schema ENABLE ROW LEVEL SECURITY;

-- Drop policy if it exists, then create it
DROP POLICY IF EXISTS tenant_isolation_policy ON pareto.schema;
CREATE POLICY tenant_isolation_policy ON pareto.schema
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);




