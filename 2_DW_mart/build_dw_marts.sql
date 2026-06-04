




-- .read build_dw_marts.sql

-- Step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW - Load data from CSV files into star schema
.read 02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart (denormalized table)
.read

-- Step 4: Mart - Create skills demand mart
.read

-- Step 5: Mart - Create priority mart
.read

-- Step 6: Mart - Update priority mart
.read

-- Step 7: Mart - Create company prospecting mart
.read
