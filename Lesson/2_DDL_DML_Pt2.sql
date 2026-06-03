-- CTAS
USE data_jobs;

CREATE OR REPLACE TABLE jobs_mart.staging.job_postings_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    jpf.company_id,
    cd.link,
    cd.link_google,
    cd.thumbnail,
    cd.name    AS company_name
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id;

SELECT COUNT(*) FROM jobs_mart.staging.job_postings_flat;

-- VIEW
USE jobs_mart;

SELECT * FROM staging.priority_roles;

CREATE OR REPLACE VIEW staging.priority_job_flat_view AS
SELECT *
FROM staging.job_postings_flat
WHERE job_title_short IN (SELECT role_name FROM staging.priority_roles WHERE priority_lvl = 1);

SELECT
    job_title_short,
    COUNT(*) AS job_count
FROM staging.priority_job_flat_view
GROUP BY job_title_short;

-- Temp
CREATE OR REPLACE TEMPORARY TABLE temp_priority_job_flat AS
SELECT *
FROM staging.job_postings_flat
WHERE job_title_short IN (SELECT role_name FROM staging.priority_roles WHERE priority_lvl = 1);

SELECT * FROM temp_priority_job_flat
LIMIT 5;

-- DELETE/TRUNCATE/DROP
DELETE FROM staging.job_postings_flat
WHERE job_posted_date < '2024-01-01';

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_job_flat_view;
SELECT COUNT(*) FROM temp_priority_job_flat;

TRUNCATE TABLE staging.job_postings_flat;

INSERT INTO staging.job_postings_flat
    SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    jpf.company_id,
    cd.link,
    cd.link_google,
    cd.thumbnail,
    cd.name    AS company_name
    FROM data_jobs.job_postings_fact AS jpf
    LEFT JOIN data_jobs.company_dim AS cd
        ON jpf.company_id = cd.company_id
    WHERE job_posted_date < '2024-01-01';

    -- CTE Subquery
    
    SELECT *
    FROM data_jobs.job_postings_fact AS tgt
    WHERE NOT EXISTS (
        SELECT 1
        FROM data_jobs.skills_job_dim src
        WHERE tgt.job_id = src.job_id
    )
    ORDER BY job_id
    LIMIT 10;