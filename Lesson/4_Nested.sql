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