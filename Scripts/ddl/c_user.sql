-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE TABLE pareto.user (  
  id                    UUID         NOT NULL DEFAULT GEN_RANDOM_UUID(),
  username              TEXT         NOT NULL,
  email                 TEXT         NOT NULL,
  full_name             TEXT         NOT NULL,
  created_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by            TEXT         NOT NULL,
  updated_at            TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_by            TEXT         NOT NULL,
  is_active             BOOLEAN      NOT NULL DEFAULT TRUE
);

ALTER TABLE pareto.user
  ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX user_alt_key on pareto.user(LOWER(username));
CREATE UNIQUE INDEX user_email on pareto.user(LOWER(email));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.user
    FOR EACH ROW
      EXECUTE FUNCTION update_at();
