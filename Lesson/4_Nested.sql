-- ARRAY
SELECT [1,2,3];

WITH nums AS(
    SELECT 'sql' AS num
    UNION ALL
    SELECT 'r'
    UNION ALL
    SELECT 'p'
), nums_array AS(
    SELECT ARRAY_AGG(num ORDER BY num) AS n
    FROM nums
)

SELECT 
    n[1] AS one,
    n[2] AS two,
    n[3] AS three,
FROM nums_array;




-- STRUCT
SELECT {skill: 'python', difficulty: 'high'};

WITH skill_struct AS (
    SELECT
        STRUCT_PACK(
            skill := ['python', 'r'],
            difficulty := 'high'
        ) AS s
) 

SELECT s.skill[1] AS one
FROM skill_struct;

WITH tab AS (
    SELECT 'sql' AS skills, 'low' AS difficulty
        UNION ALL
        SELECT 'r', 'high'
        UNION ALL
        SELECT 'p', 'mid'
)
SELECT
    STRUCT_PACK(
        skill := skills,
        difficulty := difficulty
    )
FROM tab;





-- Array of Structs
SELECT [
    {skill: 'p', difficulty: 'high'},
    {skill: 'sql', difficulty: 'low'}
];

WITH tab AS (
    SELECT 'sql' AS skills, 'low' AS difficulty
        UNION ALL
        SELECT 'r', 'high'
        UNION ALL
        SELECT 'p', 'mid'
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            difficulty := difficulty
        )
    )[1].skill AS one
FROM tab;






-- map
WITH this AS(
    SELECT MAP{'skill':'python', 'type':'programming'} AS skill_type
)

SELECT skill_type['skill']
FROM this;





-- JSON
WITH raw_skill_json AS(
    SELECT
        '{"skill":"python", "type":"programming"}'::JSON AS skill_JSON
), struct_skill_json AS(
    SELECT
        STRUCT_PACK(
            skill := json_extract_string(skill_JSON, '$.skill'),
            type := json_extract_string(skill_JSON, '$.type')

        ) AS skill_struct
    FROM raw_skill_json
)

SELECT
    skill_struct.skill
FROM struct_skill_json;




----------case study ---------

CREATE OR REPLACE TEMP TABLE skill_temp AS
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        ARRAY_AGG(sd.skills) AS skills_array
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sd.skill_id = sjd.skill_id
    GROUP BY 
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg;

-- Analyse median salary per skill

WITH t AS(
    select
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skills_array) as unnest_skills
    from skill_temp
)

SELECT 
    unnest_skills,
    median(NULLIF(salary_year_avg,0)) as median_salary
from t
group by unnest_skills
having median(NULLIF(salary_year_avg,0)) is not null
order by median_salary desc;





-- Array Structs case study --

create or replace temp table skill_array_struct as
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg,
        array_agg(
            struct_pack(
                skill:= sd.skills,
                type := sd.type
            )
        ) as skill_as
    FROM job_postings_fact AS jpf
    LEFT JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd
        ON sd.skill_id = sjd.skill_id
    GROUP BY 
        jpf.job_id,
        jpf.job_title_short,
        jpf.salary_year_avg;


with t as(
    select
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skill_as, recursive := true) as unnest_skills_as
    from skill_array_struct
)

select
    t.type,
    median(NULLIF(salary_year_avg,0)) as median_salary
from t
group by t.type
having median(NULLIF(salary_year_avg,0)) is not null
order by median_salary desc
limit 20;


