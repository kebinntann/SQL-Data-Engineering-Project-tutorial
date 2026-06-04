-- Load csv files from the cloud (googlecloud)

select '=== Loading company_dim table ===' as info;

insert into company_dim(company_id, name)
select company_id, name
from read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    auto_detect = true);

select '=== Loading skills_dim table ===' as info;

insert into skills_dim(skill_id, skills, type)
select skill_id, skills, type
from read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    auto_detect = true);

select '=== Loading job_postings_fact table ===' as info;

insert into job_postings_fact(
    job_id                  ,
    company_id              ,
    job_title_short         ,
    job_title               ,
    job_location            ,
    job_via                 ,
    job_schedule_type       ,
    job_work_from_home      ,
    search_location         ,
    job_posted_date         ,
    job_no_degree_mention   ,
    job_health_insurance    ,
    job_country             ,
    salary_rate             ,
    salary_year_avg         ,
    salary_hour_avg         
)
select
    job_id                  ,
    company_id              ,
    job_title_short         ,
    job_title               ,
    job_location            ,
    job_via                 ,
    job_schedule_type       ,
    job_work_from_home      ,
    search_location         ,
    job_posted_date         ,
    job_no_degree_mention   ,
    job_health_insurance    ,
    job_country             ,
    salary_rate             ,
    salary_year_avg         ,
    salary_hour_avg         
from read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    auto_detect = true);

select '=== Loading skills_job_dim table ===' as info;

insert into skills_job_dim(skill_id, job_id)
select skill_id, job_id
from read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    auto_detect = true);

-- Validate Data
select 'company_dim' as record_rows, count(*) as count from company_dim
union all
select 'skills_dim', count(*) from skills_dim
union all
select 'job_postings_fact', count(*) from job_postings_fact
union all
select 'skills_job_dim', count(*) from skills_job_dim;

select '=== company_dim sample ===' as info;
select * from company_dim limit 5;

select '=== skills_dim sample ===' as info;
select * from skills_dim limit 5;

select '=== job_postings_fact sample ===' as info;
select * from job_postings_fact limit 5;

select '=== skills_job_dim sample ===' as info;
select * from skills_job_dim limit 5;
