/*
Highest paying skills
*/

SELECT
    skills,
    COUNT(skills) AS Count_Skills,
    CAST(MEDIAN(jpf.salary_year_avg) AS INTEGER) AS median_salary
FROM  job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY 
    skills
HAVING
    COUNT(skills) > 100
ORDER BY 
    median_salary DESC
LIMIT 25;

/*
┌────────────┬──────────────┬───────────────┐
│   skills   │ Count_Skills │ median_salary │
│  varchar   │    int64     │     int32     │
├────────────┼──────────────┼───────────────┤
│ rust       │          232 │        210000 │
│ terraform  │         3248 │        184000 │
│ golang     │          912 │        184000 │
│ spring     │          364 │        175500 │
│ neo4j      │          277 │        170000 │
│ gdpr       │          582 │        169616 │
│ zoom       │          127 │        168438 │
│ graphql    │          445 │        167500 │
│ mongo      │          265 │        162250 │
│ fastapi    │          204 │        157500 │
│ django     │          265 │        155000 │
│ bitbucket  │          478 │        155000 │
│ crystal    │          129 │        154224 │
│ c          │          444 │        151500 │
│ atlassian  │          249 │        151500 │
│ typescript │          388 │        151000 │
│ kubernetes │         4202 │        150500 │
│ css        │          262 │        150000 │
│ ruby       │          736 │        150000 │
│ node       │          179 │        150000 │
│ airflow    │         9996 │        150000 │
│ redis      │          605 │        149000 │
│ vmware     │          136 │        148798 │
│ ansible    │          475 │        148798 │
│ jupyter    │          400 │        147500 │
└────────────┴──────────────┴───────────────┘
  25 rows                         3 columns
*/