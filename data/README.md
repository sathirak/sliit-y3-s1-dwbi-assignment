# Data Files

This folder contains source data files for the DWBI ETL project.

## Files

- `source_customer_master.csv` - Customer master data
- `source_sql_sales.csv` - **Large file (105.51 MB)** - Sales transaction data (not tracked in Git due to size)
- `fact_completion_updates.csv` - Completion updates data

## Note on Large Files

The `source_sql_sales.csv` file is excluded from Git tracking because it exceeds GitHub's 100 MB file size limit. 

**Location:** This file is stored locally at `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\data\source_sql_sales.csv`

If you clone this repository, you'll need to:
1. Obtain the `source_sql_sales.csv` file separately
2. Place it in the `data/` folder
3. Or generate it using your data source
