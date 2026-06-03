CREATE OR REPLACE TABLE jobs_mart.staging.priority_roles(
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR,
    priority_lvl INTEGER
);

INSERT INTO jobs_mart.staging.priority_roles(
    role_id,
    role_name,
    priority_lvl
)
VALUES
    (1, 'Data Engineer', 2),
    (2, 'Senior Data Engineer', 1),
    (3, 'Software Engineer', 4),
    (4, 'Data Scientist', 5);

SELECT * FROM staging.priority_roles;
