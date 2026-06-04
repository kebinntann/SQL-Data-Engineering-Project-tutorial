-- Step 1: DW - Create star schema tables

drop table if exists skills_job_dim;
drop table if exists job_postings_fact;
drop table if exists company_dim;
drop table if exists skills_dim;

create or replace table company_dim (
    company_id  integer     primary key,
    name        varchar
);

create or replace table skills_dim (
    skill_id    integer     primary key,
    skills       varchar,
    type        varchar
);

create or replace table job_postings_fact (
    job_id                  integer     primary key,
    company_id              integer,
    job_title_short         varchar,
    job_title               varchar,
    job_location            varchar,
    job_via                 varchar,
    job_schedule_type       varchar,
    job_work_from_home      boolean,
    search_location         varchar,
    job_posted_date         timestamp,
    job_no_degree_mention   boolean,
    job_health_insurance    boolean,
    job_country             varchar,
    salary_rate             varchar,
    salary_year_avg         double,
    salary_hour_avg         double,
    foreign key (company_id) references company_dim(company_id)
);

create or replace table skills_job_dim (
    skill_id    integer,
    job_id      integer,
    primary key (skill_id, job_id),
    foreign key (skill_id) references skills_dim(skill_id),
    foreign key (job_id) references job_postings_fact(job_id)
);

select table_name
from information_schema.tables
where table_schema = 'main'

-- duckdb dw_marts.duckdb -c ".read 01_create_tables_dw.sql"