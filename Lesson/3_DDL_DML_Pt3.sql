
/*
CREATE OR REPLACE TABLE main.priority_jobs_snapshot(
    job_id INTEGER,
    job_title_short VARCHAR,
    company_name VARCHAR,
    job_posted_date TIMESTAMP,
    salary_year_avg FLOAT,
    priority_lvl INTEGER,
    updated_at TIMESTAMP
);

SELECT * FROM information_schema.tables WHERE table_catalog = 'jobs_mart';

INSERT INTO priority_jobs_snapshot(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM data_jobs.main.job_postings_fact AS jpf
LEFT JOIN data_jobs.main.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN jobs_mart.staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name
;

SELECT
    job_title_short,
    COUNT(*),
    MIN(priority_lvl),
    MIN(updated_at)
FROM priority_jobs_snapshot
GROUP BY job_title_short;
*/
----------------

-- Create Temp Table
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM data_jobs.main.job_postings_fact AS jpf
LEFT JOIN data_jobs.main.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN jobs_mart.staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name;

/*
-- Update statement
UPDATE main.priority_jobs_snapshot AS tgt
SET
    priority_lvl = src.priority_lvl
FROM src_priority_jobs AS src
WHERE tgt.job_id = src.job_id
    AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;


--------------------------------

--INSERT Statement
INSERT INTO main.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
SELECT
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
FROM src_priority_jobs AS src
WHERE NOT EXISTS (
    SELECT 1
    FROM main.priority_jobs_snapshot AS tgt
    WHERE tgt.job_id = src.job_id
);

-- Delete Statement
DELETE FROM main.priority_jobs_snapshot AS tgt
WHERE NOT EXISTS(
    SELECT 1
    FROM src_priority_jobs
    WHERE tgt.job_id = src.job_id
);
*/

-- MERGE 
MERGE INTO main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

-- UPDATE (Column Values)
WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

-- INSERT (Rows)
WHEN NOT MATCHED BY TARGET THEN
    INSERT(
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
    VALUES(
        src.job_id,
        src.job_title_short,
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )

-- DELETE (ROWS)
WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Final Eval .read 'Lesson\3_DDL_DML_Pt3.sql'
SELECT
    job_title_short,
    COUNT(*),
    MIN(priority_lvl),
    MIN(updated_at)
FROM priority_jobs_snapshot
GROUP BY job_title_short;

