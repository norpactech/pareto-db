create role web_anon nologin;
grant usage on schema pareto to web_anon;
grant select on all tables in schema pareto to web_anon;

-- create role web_update with login password 'password';
create role web_update nologin;
grant usage on schema pareto TO web_update;
grant all privileges on all tables in schema pareto to web_update;
grant all privileges on all functions in schema pareto to web_update;