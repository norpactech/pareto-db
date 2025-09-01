-- Setup RLS for multi-tenancy (run as postgres user)
-- This must be run by a user who owns the tables

\echo '=== Setting up RLS for Multi-tenancy ==='

-- Enable RLS on tenant table
ALTER TABLE pareto.tenant ENABLE ROW LEVEL SECURITY;

-- Create policy for tenant table
DROP POLICY IF EXISTS tenant_isolation_policy ON pareto.tenant;
CREATE POLICY tenant_isolation_policy ON pareto.tenant
  FOR ALL TO web_update
  USING (id = current_setting('app.current_tenant')::uuid);

-- Enable RLS on schema table  
ALTER TABLE pareto.schema ENABLE ROW LEVEL SECURITY;

-- Create policy for schema table
DROP POLICY IF EXISTS tenant_isolation_policy ON pareto.schema;
CREATE POLICY tenant_isolation_policy ON pareto.schema
  FOR ALL TO web_update
  USING (id_tenant = current_setting('app.current_tenant')::uuid);

\echo '=== Setting up RLS Policy for pareto.context ==='

ALTER TABLE pareto.context ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS allow_all_policy ON pareto.context;
CREATE POLICY allow_all_policy ON pareto.context
  FOR ALL TO web_update
  USING (true);

-- Grant permissions to web_update user
GRANT SELECT, INSERT, UPDATE, DELETE ON pareto.tenant TO web_update;
GRANT SELECT, INSERT, UPDATE, DELETE ON pareto.schema TO web_update;
GRANT SELECT, INSERT, UPDATE, DELETE ON pareto.context TO web_update;

\echo '=== RLS Setup Complete ==='