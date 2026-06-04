-- Create flat mart

drop schema if exists flat_mart cascade;

create schema flat_mart;

create or replace table flat_mart.jobs_flat as
select
    jpf.job_id                  ,
    jpf.company_id              ,
    jpf.job_title_short         ,
    jpf.job_title               ,
    jpf.job_location            ,
    jpf.job_via                 ,
    jpf.job_schedule_type       ,
    jpf.job_work_from_home      ,
    jpf.search_location         ,
    jpf.job_posted_date         ,
    jpf.job_no_degree_mention   ,
    jpf.job_health_insurance    ,
    jpf.job_country             ,
    jpf.salary_rate             ,
    jpf.salary_year_avg         ,
    jpf.salary_hour_avg         ,
    cd.company_id               ,
    cd.name                     ,
    array_agg(
        struct_pack(
            name := sd.skills,
            type := sd.type
        )
    ) as skill_type               
from 
    job_postings_fact as jpf
left join
    company_dim as cd
    on jpf.company_id = cd.company_id
left join
    skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
left join
    skills_dim as sd
    on sjd.skill_id = sd.skill_id
group by all;

select * from information_schema.tables;

-- Data validation

select 'Flat Mart Job Postings' as table_name, count(*) as record_rows from flat_mart.jobs_flat;

select '=== flat mart sample ===' as info;
select * from flat_mart.jobs_flat limit 5;