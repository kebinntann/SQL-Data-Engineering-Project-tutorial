




-- .read build_dw_marts.sql

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
TO 'C:/Users/KT/PowerBI/csvfiles/fm_jobs_flat.csv'
(FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY skill_mart.fact_skill_demand_monthly
TO 'C:/Users/KT/PowerBI/csvfiles/sm_fact_skill_demand_monthly.csv'
(FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY skill_mart.dim_date_month
TO 'C:/Users/KT/PowerBI/csvfiles/sm_dim_date_month.csv'
(FORMAT CSV, HEADER TRUE, DELIMITER ',');

COPY skill_mart.dim_skills
TO 'C:/Users/KT/PowerBI/csvfiles/sm_dim_skills.csv'
(FORMAT CSV, HEADER TRUE, DELIMITER ',');