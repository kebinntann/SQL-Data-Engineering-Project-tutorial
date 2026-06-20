with aggregated as (
    select 
        f.job_title_short,
        ds.skills,
        ds.type,
        ddm.year_quarter,
        sum(f.postings_count) as total_postings
    from skill_mart.dim_skills as ds
    inner join
        skill_mart.fact_skill_demand_monthly as f
        on f.skill_id = ds.skill_id
    inner join 
        skill_mart.dim_date_month as ddm
        on f.month_start_date = ddm.month_start_date
    where job_title_short = 'Senior Data Engineer'
    group by ddm.year_quarter, f.job_title_short, ds.skills, ds.type
),
ranked as (
    select 
        *,
        rank() over(partition by year_quarter, job_title_short order by total_postings desc) as top_skill
    from aggregated
)
select *
from ranked
where top_skill = 1
order by total_postings desc;