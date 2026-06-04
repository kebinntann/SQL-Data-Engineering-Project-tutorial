-- Create Skill data mart

drop schema if exists skill_mart cascade;
create schema skill_mart;




-- dim skill table
create or replace table skill_mart.dim_skills (
    skill_id    integer     primary key,
    skills      varchar,
    type        varchar
);

insert into skill_mart.dim_skills (
    skill_id,
    skills,
    type
)
select
    skill_id,
    skills,
    type   
from skills_dim;




-- dim date table
create or replace table skill_mart.dim_date_month (
    month_start_date    date    primary key,
    year                integer,
    month               integer,
    quarter             integer,
    quarter_name        varchar,
    year_quarter        varchar
);

insert into skill_mart.dim_date_month(
    month_start_date    ,
    year                ,
    month               ,
    quarter             ,
    quarter_name        ,
    year_quarter        
)
select distinct
    date_trunc('month', job_posted_date)::date as month_start_date,
    extract(year from job_posted_date) as year,
    extract(month from job_posted_date) as month,
    extract(quarter from job_posted_date) as quarter,
    case
        when extract(quarter from job_posted_date) = 1 then 'Q1'
        when extract(quarter from job_posted_date) = 2 then 'Q2'
        when extract(quarter from job_posted_date) = 3 then 'Q3'
        when extract(quarter from job_posted_date) = 4 then 'Q4'
        else null
    end as quarter_name,
    case
        when extract(quarter from job_posted_date) = 1 then extract(year from job_posted_date) || '-' || 'Q1'
        when extract(quarter from job_posted_date) = 2 then extract(year from job_posted_date) || '-' || 'Q2'
        when extract(quarter from job_posted_date) = 3 then extract(year from job_posted_date) || '-' || 'Q3'
        when extract(quarter from job_posted_date) = 4 then extract(year from job_posted_date) || '-' || 'Q4'
        else null
    end as year_quarter

from job_postings_fact
order by month_start_date;




-- fact skill demand monthly
create or replace table skill_mart.fact_skill_demand_monthly (
    skill_id                                        integer,
    month_start_date                                date,
    job_title_short                                 varchar,
    postings_count                                  integer,
    remote_postings_count                           integer,
    health_insurance_postings_count                 integer,
    no_degree_mentioned_postings_count              integer,
    primary key (skill_id, month_start_date, job_title_short),
    foreign key (skill_id) references skill_mart.dim_skills(skill_id),
    foreign key (month_start_date) references skill_mart.dim_date_month(month_start_date)
);

insert into skill_mart.fact_skill_demand_monthly(
    skill_id                                        ,
    month_start_date                                ,
    job_title_short                                 ,
    postings_count                                  ,
    remote_postings_count                           ,
    health_insurance_postings_count                 ,
    no_degree_mentioned_postings_count              
)
with t as(
    select
        sjd.skill_id,
        date_trunc('month', jpf.job_posted_date)::date as month_start_date,
        jpf.job_title_short,
        -- convert boolean
        case when jpf.job_work_from_home = true then 1 else 0 end as is_remote,
        case when jpf.job_health_insurance = true then 1 else 0 end as has_health_insurance,
        case when jpf.job_no_degree_mention = true then 1 else 0 end as no_degree_mentioned,
    from
        job_postings_fact as jpf
    inner join
        skills_job_dim as sjd
        on sjd.job_id = jpf.job_id
)
select
    skill_id,
    month_start_date,
    job_title_short,
    count(*) as postings_count,
    sum(is_remote) as remote_postings_count,
    sum(has_health_insurance) as health_insurance_postings_count,
    sum(no_degree_mentioned) as no_degree_mentioned_postings_count
from t
where job_title_short like '%Data Engineer%'
group by all
order by skill_id, month_start_date, job_title_short;






-- Data validation
select 'dim skill' as table_name, count(*) as record_rows from skill_mart.dim_skills
union all
select 'dim date month', count(*) from skill_mart.dim_date_month
union all
select 'fact skill demand monthly', count(*) from skill_mart.fact_skill_demand_monthly;

select '=== dim skill sample ===' as info;
select * from skill_mart.dim_skills limit 5;

select '=== dim date month sample ===' as info;
select * from skill_mart.dim_date_month limit 5;

select '=== fact skill demand monthly sample ===' as info;
select * from skill_mart.fact_skill_demand_monthly limit 5;
