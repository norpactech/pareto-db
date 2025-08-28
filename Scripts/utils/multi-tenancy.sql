-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

-- Enable RLS on all tenant tables
ALTER TABLE pareto.schema ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.validation ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.ref_table_type ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.generic_data_type ENABLE ROW LEVEL SECURITY;
ALTER TABLE pareto.tenant_user ENABLE ROW LEVEL SECURITY;

-- Create policies for each table
DROP POLICY tenant_isolation_policy ON pareto.schema;
CREATE POLICY tenant_isolation_policy ON pareto.schema
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

DROP POLICY tenant_isolation_policy ON pareto.validation;
CREATE POLICY tenant_isolation_policy ON pareto.validation
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

DROP POLICY tenant_isolation_policy ON pareto.ref_table_type;
CREATE POLICY tenant_isolation_policy ON pareto.ref_table_type
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

DROP POLICY tenant_isolation_policy ON pareto.generic_data_type;
CREATE POLICY tenant_isolation_policy ON pareto.generic_data_type
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

DROP POLICY tenant_isolation_policy ON pareto.tenant_user;
CREATE POLICY tenant_isolation_policy ON pareto.tenant_user
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);
