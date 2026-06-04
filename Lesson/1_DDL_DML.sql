-- DDL

USE data_jobs;

CREATE DATABASE IF NOT EXISTS jobs_mart;

-- DROP DATABASE  IF EXISTS jobs_mart;

SELECT * FROM information_schema.schemata;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS staging;

-- DROP SCHEMA IF EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT * FROM information_schema.tables WHERE table_catalog = 'jobs_mart';

--DROP TABLE staging.preferred_roles;

-----------------------------------------------------------------

-- DML

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;
--DROP COLUMN preferred_role;

UPDATE staging.preferred_roles
SET preferred_role = True
WHERE role_name LIKE '%Data%';

UPDATE staging.preferred_roles
SET preferred_role = False
WHERE role_name NOT LIKE '%Data%';

--ALTER Name/TYPE of Table/Column

SELECT * FROM staging.priority_roles;

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

