-- ---------------------------------------------------------------------------------------
-- Table: pareto.tenant_user. Generated by Pareto Factory™ "Be Consistent"
-- ---------------------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.tenant_user CASCADE;

CREATE TABLE pareto.tenant_user (
  id_tenant                        UUID             NOT NULL, 
  id_user                          UUID             NOT NULL
);

ALTER TABLE pareto.tenant_user ADD PRIMARY KEY (id_tenant, id_user);

ALTER TABLE pareto.tenant_user
  ADD CONSTRAINT tenant_user_id_tenant
  FOREIGN KEY (id_tenant)
  REFERENCES pareto.tenant(id)
  ON DELETE CASCADE;
    
ALTER TABLE pareto.tenant_user
  ADD CONSTRAINT tenant_user_id_user
  FOREIGN KEY (id_user)
  REFERENCES pareto.user(id)
  ON DELETE CASCADE;
