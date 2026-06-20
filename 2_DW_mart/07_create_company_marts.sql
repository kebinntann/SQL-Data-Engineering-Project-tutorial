drop schema if exists company_mart cascade;
create schema company_mart;

-- dim_job_title
create or replace table company_mart.dim_job_title (
    job_title_id        integer     primary key,
    job_title           varchar
);

insert into company_mart.dim_job_title (
    job_title_id,
    job_title
)
select
    row_number() over(order by job_title) as job_title_id,
    job_title
from job_postings_fact
group by job_title;


-- dim job title short
create or replace table company_mart.dim_job_title_short (
    job_title_short_id        integer     primary key,
    job_title_short           varchar
);

insert into company_mart.dim_job_title_short (
    job_title_short_id,
    job_title_short
)
select
    row_number() over(order by job_title_short) as job_title_short_id,
    job_title_short
from job_postings_fact
group by job_title_short;


-- mapping bridge jt-js
create or replace table company_mart.mapping_bridge as
select distinct
    job_title,
    job_title_short
from job_postings_fact;



-- job bridge
create or replace table company_mart.bridge_job_title (
    job_title_short_id        integer,
    job_title_id              integer,
    primary key (job_title_short_id, job_title_id),
    foreign key (job_title_short_id) references company_mart.dim_job_title_short(job_title_short_id),
    foreign key (job_title_id) references company_mart.dim_job_title(job_title_id)
);

insert into company_mart.bridge_job_title (
    job_title_short_id,
    job_title_id
)
select
    js.job_title_short_id,
    j.job_title_id
from company_mart.dim_job_title as j
    inner join company_mart.mapping_bridge as m
    on j.job_title = m.job_title
    inner join company_mart.dim_job_title_short as js
    on js.job_title_short = m.job_title_short;
 



-- dim date month
create or replace table company_mart.dim_date_month (
    month_start_date    date    primary key,
    year                integer,
    month               integer,
    quarter             integer,
    quarter_name        varchar,
    year_quarter        varchar
);

insert into company_mart.dim_date_month (
    month_start_date    ,
    year                ,
    month               ,
    quarter             ,
    quarter_name        ,
    year_quarter        
)
select *
from skill_mart.dim_date_month;



-- dim location
create or replace table company_mart.dim_location (
    location_id             integer         primary key,
    job_location            varchar,
    job_country             varchar
);

insert into company_mart.dim_location(
    location_id,
    job_location,
    job_country
)
select
    row_number() over (order by job_location) as location_id,
    job_location,
    max(job_country) as job_country
from job_postings_fact
group by job_location;




-- dim company
create or replace table company_mart.dim_company (
    company_id          integer     primary key,
    company_name        varchar
);

insert into company_mart.dim_company (
    company_id,
    company_name
)
select
    company_id,
    name
from company_dim;



-- mapping bridge c-l
create or replace table company_mart.mapping_bridge_cl as
select distinct
    company_id,
    job_location
from job_postings_fact;



-- company location bridge
create or replace table company_mart.bridge_company_location (
    company_id          integer,
    location_id         integer,
    primary key (company_id, location_id),
    foreign key (company_id) references company_mart.dim_company(company_id),
    foreign key (location_id) references company_mart.dim_location(location_id)
);

insert into company_mart.bridge_company_location (
    company_id,
    location_id
)
select
    c.company_id,
    l.location_id
from company_mart.dim_location as l
    inner join company_mart.mapping_bridge_cl as m
    on l.job_location = m.job_location
    inner join company_mart.dim_company as c
    on c.company_id = m.company_id;






-- fact_company_hiring_month
create or replace table company_mart.fact_company_hiring_month (
    company_id                      integer,
    job_title_short_id              integer,
    month_start_date                date,
    job_country                     varchar,
    postings_count                  integer,
    median_salary_year              integer,
    min_salary_year                 integer,
    max_salary_year                 integer,
    primary key (company_id, job_title_short_id, month_start_date,job_country),
    foreign key (company_id) references company_mart.dim_company(company_id),
    foreign key (job_title_short_id) references company_mart.dim_job_title_short(job_title_short_id),
    foreign key (month_start_date) references company_mart.dim_date_month(month_start_date)
);

insert into company_mart.fact_company_hiring_month (
    company_id                      ,
    job_title_short_id              ,
    month_start_date                ,
    job_country                     ,
    postings_count                  ,
    median_salary_year              ,
    min_salary_year                 ,
    max_salary_year                 
)
select
    jpf.company_id,
    djs.job_title_short_id,
    date_trunc('month', jpf.job_posted_date)::date as month_start_date,
    jpf.job_country,
    count(*) as postings_count,
    median(jpf.salary_year_avg) as median_salary_year,
    min(jpf.salary_year_avg) as min_salary_year,
    max(jpf.salary_year_avg) as max_salary_year
from job_postings_fact as jpf
    left join company_mart.dim_job_title_short as djs
    on jpf.job_title_short = djs.job_title_short
where jpf.job_country is not null 
--and jpf.salary_year_avg is not null
group by all
order by jpf.company_id, djs.job_title_short_id, month_start_date, jpf.job_country;


