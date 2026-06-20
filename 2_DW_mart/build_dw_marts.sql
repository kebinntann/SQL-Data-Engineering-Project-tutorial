




-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW - Load data from CSV files into star schema
.read 02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart (denormalized table)
.read 03_create_flat_mart.sql

-- Step 4: Mart - Create skills demand mart
.read 04_create_skills_mart.sql

-- Step 5: Mart - Create priority mart
.read 05_create_priority_mart.sql

-- Step 6: Mart - Update priority mart
.read 06_update_priority_mart.sql

-- Step 7: Mart - Create company prospecting mart
.read 07_create_company_marts.sql




COPY flat_mart.jobs_flat
TO 'C:/Users/KT/PowerBI/parquetfiles/fm_jobs_flat.parquet'
(FORMAT parquet);

--------------------------------------------------------

COPY skill_mart.fact_skill_demand_monthly
TO 'C:/Users/KT/PowerBI/parquetfiles/sm_fact_skill_demand_monthly.parquet'
(FORMAT parquet);

COPY skill_mart.dim_date_month
TO 'C:/Users/KT/PowerBI/parquetfiles/sm_dim_date_month.parquet'
(FORMAT parquet);

COPY skill_mart.dim_skills
TO 'C:/Users/KT/PowerBI/parquetfiles/sm_dim_skills.parquet'
(FORMAT parquet);

-----------------------------------------------------------------

COPY company_mart.dim_job_title
TO 'C:/Users/KT/PowerBI/parquetfiles/cm_dim_job_title.parquet'
(FORMAT parquet);

COPY company_mart.bridge_job_title
TO 'C:/Users/KT/PowerBI/parquetfiles/cm_bridge_job_title.parquet'
(FORMAT parquet);

COPY company_mart.dim_job_title_short
TO 'C:/Users/KT/PowerBI/parquetfiles/cm_dim_job_title_short.parquet'
(FORMAT parquet);

COPY company_mart.fact_company_hiring_month
TO 'C:/Users/KT/PowerBI/parquetfiles/cm_fact_company_hiring_month.parquet'
(FORMAT parquet);

COPY company_mart.dim_date_month
TO 'C:/Users/KT/PowerBI/parquetfiles/cm_dim_date_month.parquet'
(FORMAT parquet);

COPY company_mart.dim_location
TO 'C:/Users/KT/PowerBI/parquetfiles/cm_dim_location.parquet'
(FORMAT parquet);

COPY company_mart.bridge_company_location
TO 'C:/Users/KT/PowerBI/parquetfiles/cm_bridge_company_location.parquet'
(FORMAT parquet);

COPY company_mart.dim_company
TO 'C:/Users/KT/PowerBI/parquetfiles/cm_dim_company.parquet'
(FORMAT parquet);

select ' === finish ===' as completion_status;