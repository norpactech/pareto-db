-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.user (  
  id                    pk,
  username              username,
  email                 email         not null,
  full_name             generic_name  not null,
  created_at            timestamp_at,
  created_by            username,
  updated_at            timestamp_at,
  updated_by            username,
  is_active             active
);

ALTER TABLE pareto.user
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX user_alt_key on pareto.user(LOWER(username));
CREATE UNIQUE INDEX user_email on pareto.user(LOWER(email));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.user
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
