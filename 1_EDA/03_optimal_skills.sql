/* 
Most optimal skills balancing both demand and salary
*/

SELECT
    skills,
    CAST(MEDIAN(jpf.salary_year_avg) AS INTEGER) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count,
    ROUND(LN(COUNT(jpf.salary_year_avg)),2) AS ln_demand_count,
    ROUND(CAST(MEDIAN(jpf.salary_year_avg) AS INTEGER) * LN(COUNT(jpf.salary_year_avg))/1_000_000,2)  AS optimal_score
FROM  job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Scientist'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY 
    skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY 
    optimal_score DESC
LIMIT 25;

/*
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │     int32     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │        184000 │          193 │            5.26 │          0.97 │
│ python     │        135000 │         1133 │            7.03 │          0.95 │
│ sql        │        130000 │         1128 │            7.03 │          0.91 │
│ aws        │        137320 │          783 │            6.66 │          0.91 │
│ airflow    │        150000 │          386 │            5.96 │          0.89 │
│ spark      │        140000 │          503 │            6.22 │          0.87 │
│ snowflake  │        135500 │          438 │            6.08 │          0.82 │
│ kafka      │        145000 │          292 │            5.68 │          0.82 │
│ azure      │        128000 │          475 │            6.16 │          0.79 │
│ java       │        135000 │          303 │            5.71 │          0.77 │
│ scala      │        137290 │          247 │            5.51 │          0.76 │
│ kubernetes │        150500 │          147 │            4.99 │          0.75 │
│ git        │        140000 │          208 │            5.34 │          0.75 │
│ databricks │        132750 │          266 │            5.58 │          0.74 │
│ redshift   │        130000 │          274 │            5.61 │          0.73 │
│ gcp        │        136000 │          196 │            5.28 │          0.72 │
│ hadoop     │        135000 │          198 │            5.29 │          0.71 │
│ nosql      │        134415 │          193 │            5.26 │          0.71 │
│ pyspark    │        140000 │          152 │            5.02 │           0.7 │
│ docker     │        135000 │          144 │            4.97 │          0.67 │
│ mongodb    │        135750 │          136 │            4.91 │          0.67 │
│ go         │        140000 │          113 │            4.73 │          0.66 │
│ r          │        134775 │          133 │            4.89 │          0.66 │
│ github     │        135000 │          127 │            4.84 │          0.65 │
│ bigquery   │        135000 │          123 │            4.81 │          0.65 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
  25 rows                                                           5 columns
*/