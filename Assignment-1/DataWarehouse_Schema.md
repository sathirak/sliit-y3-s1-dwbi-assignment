# CarSalesDW - Data Warehouse Schema Documentation

## Database Overview

**Database Name**: CarSalesDW
**Purpose**: Data warehouse for car sales analytics and business intelligence
**DBMS**: Microsoft SQL Server 2025
**Date Created**: March 22, 2026
**Schema Type**: Star Schema

---

## Data Warehouse Statistics

| Component | Count | Description |
|-----------|-------|-------------|
| **Date Dimension** | 1,826 rows | Daily granularity from 2022-01-01 to 2026-12-31 |
| **Vehicle Dimension** | 326 rows | Unique car make/model/year combinations |
| **Customer Dimension** | 2,524,917 rows | Customer records with SCD Type 2 (region changes tracked) |
| **Sales Fact Table** | 2,500,000 rows | Car sales transactions with amounts and commissions |

---

## Schema Structure

### 1. Staging Schema (`stg`)

Temporary landing area for source data before transformation into dimensions and facts.

#### `stg.stg_sales`
Source data from SQL Sales CSV files.

| Column | Type | Description |
|--------|------|-------------|
| txn_id | BIGINT IDENTITY | Unique transaction identifier |
| sale_date | DATE | Date of sale |
| customer_name | NVARCHAR(200) | Customer name (nullable) |
| car_make | NVARCHAR(100) | Car manufacturer |
| car_model | NVARCHAR(100) | Car model name |
| car_year | INT | Year of manufacture |
| sale_price | DECIMAL(18,2) | Sale amount |
| commission_earned | DECIMAL(18,2) | Commission on sale |
| source_system | NVARCHAR(50) | Source system identifier |
| load_dtm | DATETIME2 | Load timestamp |

#### `stg.stg_customer`
Source data from Customer Master CSV files.

| Column | Type | Description |
|--------|------|-------------|
| customer_name | NVARCHAR(200) | Customer name |
| region | NVARCHAR(100) | Customer region |
| source_system | NVARCHAR(50) | Source system identifier |
| load_dtm | DATETIME2 | Load timestamp |

---

### 2. Dimension Tables

#### `dbo.dim_date` (Date Dimension)
Time dimension with day-level granularity.

| Column | Type | Key | Description |
|--------|------|-----|-------------|
| date_key | INT | PK | Surrogate key (format: YYYYMMDD) |
| full_date | DATE | UNIQUE | Actual date value |
| day_number | TINYINT | | Day of month (1-31) |
| month_number | TINYINT | | Month number (1-12) |
| month_name | NVARCHAR(20) | | Month name (January-December) |
| quarter_number | TINYINT | | Quarter (1-4) |
| year_number | SMALLINT | | Year (2022-2026) |
| week_of_year | TINYINT | | ISO week number |

**Hierarchy**: Year → Quarter → Month → Day

**Sample Data**:
```
date_key: 20230315
full_date: 2023-03-15
day_number: 15
month_number: 3
month_name: March
quarter_number: 1
year_number: 2023
week_of_year: 11
```

---

#### `dbo.dim_vehicle` (Vehicle Dimension)
Slowly Changing Dimension Type 1 - Vehicle attributes.

| Column | Type | Key | Description |
|--------|------|-----|-------------|
| vehicle_key | INT IDENTITY | PK | Surrogate key |
| vehicle_nk | NVARCHAR(250) | UNIQUE | Natural key: make\|model\|year |
| car_make | NVARCHAR(100) | | Manufacturer (Chevrolet, Ford, Nissan, etc.) |
| car_model | NVARCHAR(100) | | Model name (Altima, F-150, Civic, etc.) |
| car_year | INT | | Year of manufacture |
| vehicle_category | NVARCHAR(100) | | Category (default: 'Passenger') |
| record_insert_dtm | DATETIME2 | | Record creation timestamp |
| record_update_dtm | DATETIME2 | | Record update timestamp |

**SCD Type**: Type 1 (updates overwrite existing data)

**Sample Data**:
```
vehicle_key: 1
vehicle_nk: Chevrolet|Altima|2010
car_make: Chevrolet
car_model: Altima
car_year: 2010
vehicle_category: Passenger
```

**Unknown Member**: vehicle_key = 0 for unmatched/missing vehicles

---

#### `dbo.dim_customer` (Customer Dimension)
Slowly Changing Dimension Type 2 - Customer with region history tracking.

| Column | Type | Key | Description |
|--------|------|-----|-------------|
| customer_key | INT IDENTITY | PK | Surrogate key |
| customer_nk | NVARCHAR(200) | | Natural key (customer name) |
| customer_name | NVARCHAR(200) | | Customer full name |
| region | NVARCHAR(100) | | Customer region |
| effective_from | DATETIME2 | | Version start date |
| effective_to | DATETIME2 | | Version end date (9999-12-31 for current) |
| is_current | BIT | | Flag: 1 = current version, 0 = historical |
| record_insert_dtm | DATETIME2 | | Record creation timestamp |
| record_update_dtm | DATETIME2 | | Record update timestamp |

**SCD Type**: Type 2 (maintains history of region changes)

**Index**: `IX_dim_customer_nk_current` on (customer_nk, is_current)

**Unknown Member**: customer_key = 0 for unmatched/missing customers

**Historical Tracking**:
- When a customer changes region, the old record is closed (is_current = 0, effective_to = change date)
- A new record is created (is_current = 1, effective_from = change date)
- This preserves point-in-time accuracy for historical sales analysis

---

### 3. Fact Table

#### `dbo.fact_sales` (Sales Fact Table)
Core fact table storing car sales transactions.

| Column | Type | Key/FK | Description |
|--------|------|--------|-------------|
| sales_fact_key | BIGINT IDENTITY | PK | Surrogate key |
| txn_id | BIGINT | UNIQUE | Natural key from source |
| date_key | INT | FK → dim_date | Sale date |
| vehicle_key | INT | FK → dim_vehicle | Car sold |
| customer_key | INT | FK → dim_customer | Customer (point-in-time) |
| sale_amount | DECIMAL(18,2) | MEASURE | Sale price |
| commission_amount | DECIMAL(18,2) | MEASURE | Commission earned |
| accm_txn_create_time | DATETIME2 | | Transaction creation time |
| accm_txn_complete_time | DATETIME2 | | Transaction completion time |
| txn_process_time_hours | DECIMAL(18,2) | MEASURE | Processing time in hours |
| dw_insert_dtm | DATETIME2 | | DW load timestamp |

**Measures (for OLAP Cube)**:
- `sale_amount` - Total sales revenue
- `commission_amount` - Total commissions
- `txn_process_time_hours` - Transaction processing duration
- COUNT(sales_fact_key) - Number of transactions

**Foreign Keys**:
- `FK_fact_sales_date` → dim_date(date_key)
- `FK_fact_sales_vehicle` → dim_vehicle(vehicle_key)
- `FK_fact_sales_customer` → dim_customer(customer_key)

**Sample Transaction**:
```
sales_fact_key: 1
txn_id: 1
date_key: 20220801 (Aug 1, 2022)
vehicle: Nissan Altima
sale_amount: $15,983.00
commission_amount: $1,126.73
```

---

## Entity-Relationship Diagram

```
┌─────────────────┐
│   dim_date      │
│  (Time Dim)     │
│─────────────────│
│ date_key (PK)   │───┐
│ full_date       │   │
│ year_number     │   │
│ quarter_number  │   │
│ month_number    │   │
│ month_name      │   │
│ day_number      │   │
│ week_of_year    │   │
└─────────────────┘   │
                      │
┌─────────────────┐   │    ┌──────────────────┐
│  dim_vehicle    │   │    │   fact_sales     │
│ (Vehicle Dim)   │   │    │   (Fact Table)   │
│─────────────────│   │    │──────────────────│
│ vehicle_key (PK)│───┼───→│ sales_fact_key PK│
│ vehicle_nk      │   │    │ txn_id (NK)      │
│ car_make        │   └───→│ date_key (FK)    │
│ car_model       │        │ vehicle_key (FK) │
│ car_year        │    ┌──→│ customer_key (FK)│
│ category        │    │   │ sale_amount ✱    │
└─────────────────┘    │   │ commission_amt ✱ │
                       │   │ process_time_hrs✱│
┌─────────────────┐    │   └──────────────────┘
│  dim_customer   │    │
│ (Customer Dim)  │    │
│─────────────────│    │
│ customer_key PK │────┘
│ customer_nk     │
│ customer_name   │
│ region          │
│ effective_from  │
│ effective_to    │
│ is_current      │
└─────────────────┘

Legend:
PK = Primary Key
FK = Foreign Key
NK = Natural Key
✱  = Measure/Additive Metric
```

---

## Data Model Type

**Star Schema**

- **Central Fact Table**: `fact_sales`
- **Dimension Tables**: `dim_date`, `dim_vehicle`, `dim_customer`
- **Relationships**: Direct FK relationships from fact to dimensions
- **Granularity**: One row per car sale transaction
- **Time Grain**: Daily (via dim_date)

---

## ETL Process

### Source Systems
1. **SQL Sales CSV** (`source_sql_sales.csv`) - 105 MB sales transactions
2. **Customer Master CSV** (`source_customer_master.csv`) - 22 MB customer data
3. **Completion Updates CSV** (`fact_completion_updates.csv`) - Transaction updates

### ETL Flow
1. **Extract**: Load CSV files into staging tables (`stg.stg_sales`, `stg.stg_customer`)
2. **Transform**: 
   - Populate dim_date with date range
   - MERGE into dim_vehicle (SCD Type 1)
   - SCD Type 2 processing for dim_customer
   - Lookup dimension keys
3. **Load**: Insert into fact_sales with dimension keys

### SSIS Packages
- `Package.dtsx` - Main ETL workflow
- `PackageAccum.dtsx` - Accumulating snapshot processing

---

## Hierarchies for OLAP Cube

### Date Hierarchy
```
Year (year_number)
  └─ Quarter (quarter_number)
      └─ Month (month_name)
          └─ Day (day_number)
```

### Vehicle Hierarchy (Potential)
```
Car Make (car_make)
  └─ Car Model (car_model)
      └─ Car Year (car_year)
```

### Customer Hierarchy (Potential)
```
Region (region)
  └─ Customer (customer_name)
```

---

## Usage for Assignment 2

This data warehouse serves as the **required data source for Assignment 2 SSAS Cube**.

**Next Steps**:
1. Create SSAS project connecting to CarSalesDW
2. Define cube with fact_sales measures
3. Add dimensions: Date, Vehicle, Customer
4. Implement hierarchies (especially Date hierarchy)
5. Deploy to SSAS for Excel and PowerBI consumption

---

## Technical Notes

- **Database Collation**: SQL_Latin1_General_CP1_CI_AS (default)
- **Recovery Model**: Simple
- **Compatibility Level**: SQL Server 2025 (170)
- **Data Volume**: ~2.5M transactions, ~2.5M customer versions
- **Date Range**: 2022-2026 (5 years)
- **Unknown Members**: Both dimensions include key=0 for unmatched records

---

*Document Created*: March 28, 2026
*Data Warehouse Version*: 1.0 (Assignment 1 Complete)
