-- -----------------------------------------------------------------------------
-- Table: pareto.user. Generated by Pareto Factory™
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS pareto.user CASCADE;

CREATE TABLE pareto.user (
  id                               UUID             NOT NULL  DEFAULT GEN_RANDOM_UUID(), 
  username                         VARCHAR(32)      NOT NULL  CHECK ( username ~ '^[a-zA-Z][a-zA-Z0-9_-]{2,31}$'), 
  email                            VARCHAR(126)     NOT NULL  CHECK ( email ~ '^[A-Za-z0-9]+([._%+-][A-Za-z0-9]+)*@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'), 
  full_name                        VARCHAR(32)      NOT NULL, 
  created_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  created_by                       VARCHAR(32)      NOT NULL, 
  updated_at                       TIMESTAMP        NOT NULL  DEFAULT CURRENT_TIMESTAMP, 
  updated_by                       VARCHAR(32)      NOT NULL, 
  is_active                        BOOLEAN          NOT NULL  DEFAULT TRUE
);

ALTER TABLE pareto.user ADD PRIMARY KEY (id);

CREATE UNIQUE INDEX user_alt_key 
    ON pareto.user(LOWER(username));

CREATE UNIQUE INDEX user_idx01 
    ON pareto.user(LOWER(email));

CREATE TRIGGER update_at
  BEFORE UPDATE ON pareto.user 
    FOR EACH ROW
      EXECUTE FUNCTION update_at();