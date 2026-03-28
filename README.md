# DWBI Assignment - Data Warehousing & Business Intelligence

This repository contains all files and projects for the DWBI assignment, organized into a structured format.

## 📁 Project Structure

```
dwbi-assignment/
├── data/                          # Source data files
│   ├── source_customer_master.csv
│   ├── source_sql_sales.csv
│   └── fact_completion_updates.csv
│
├── sql/                           # SQL scripts
│   ├── task4_dw_schema.sql       # Data warehouse schema
│   └── task5_etl_sql_support.sql # ETL support scripts
│
├── etl/                           # SSIS ETL Projects
│   ├── CarSalesETL/              # Main ETL project
│   │   ├── Package.dtsx          # SSIS packages
│   │   ├── PackageAccum.dtsx
│   │   ├── CarSalesETL.dtproj    # Project files
│   │   └── Project.params        # Project parameters
│   └── CarSalesETL.slnx          # Visual Studio solution
│
└── docs/                          # Documentation
```

## 🚀 Getting Started

### Prerequisites
- SQL Server Management Studio (SSMS)
- Visual Studio with SQL Server Integration Services (SSIS)
- SQL Server Database Engine

### Setup Instructions

1. **Database Setup**
   - Run `sql/task4_dw_schema.sql` to create the data warehouse schema
   - Run `sql/task5_etl_sql_support.sql` for ETL support structures

2. **ETL Project**
   - Open `etl/CarSalesETL.slnx` in Visual Studio
   - Configure connection managers in the SSIS packages
   - Deploy and execute the ETL packages

3. **Data Files**
   - Source data files are located in the `data/` directory
   - Update file paths in SSIS packages if needed

## 📝 Notes

This project was consolidated from multiple locations:
- Downloads folder (SQL scripts and CSV files)
- Projects/dwbi folder (data files)
- source/repos/CarSalesETL (SSIS project)

All files have been organized into this centralized git repository for better version control and collaboration.
