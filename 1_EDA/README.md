# HEADING

**Bold** Not Bold  
`This is code`  

- Bullet 1
1. Num 1

[Link Text](https://google.com)  
![Alt Text](../Images\wp9055017.jpg)

```sql
SELECT
    skills,
    COUNT(skills) AS Count_Skills
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
ORDER BY 
    Count_Skills DESC
LIMIT 10;
```
[Top Demand Skills](01_top_demanded_skills.sql)