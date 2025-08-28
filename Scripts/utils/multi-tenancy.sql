-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

-- Enable RLS on all tenant tables
ALTER TABLE pareto.schema ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.project ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.project_component ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.validation ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.ref_table_type ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.generic_data_type ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.tenant_user ENABLE ROW LEVEL SECURITY;

-- Direct tenant tables (have id_tenant column)
CREATE POLICY tenant_isolation_policy ON pareto.schema
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

CREATE POLICY tenant_isolation_policy ON pareto.validation
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

CREATE POLICY tenant_isolation_policy ON pareto.ref_table_type
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

CREATE POLICY tenant_isolation_policy ON pareto.generic_data_type
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

CREATE POLICY tenant_isolation_policy ON pareto.tenant_user
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

-- Child tables (use foreign key relationships for tenant isolation)
CREATE POLICY tenant_isolation_policy ON pareto.project
  FOR ALL TO web_update
  USING (id_schema IN (
    SELECT id FROM pareto.schema 
    WHERE id_tenant = current_setting('app.current_tenant')::uuid
  ));

-- Grandchild tables (use chained foreign key relationships for tenant isolation)
CREATE POLICY tenant_isolation_policy ON pareto.project_component
  FOR ALL TO web_update
  USING (id_project IN (
    SELECT p.id FROM pareto.project p
    JOIN pareto.schema s ON p.id_schema = s.id
    WHERE s.id_tenant = current_setting('app.current_tenant')::uuid
  ));