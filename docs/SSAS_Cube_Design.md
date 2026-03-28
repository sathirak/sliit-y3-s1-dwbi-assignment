# SSAS Cube Design - CarSalesCube

## Cube Overview

**Cube Name**: CarSalesCube
**Type**: Multidimensional OLAP (MOLAP)
**Data Source**: CarSalesDW (SQL Server 2025)
**Purpose**: Business intelligence analysis of car sales data

---

## Data Source Configuration

### Connection Details
- **Server**: localhost (or DESKTOP-EQ55Q8H)
- **Database**: CarSalesDW
- **Authentication**: Windows Authentication
- **Provider**: SQL Server Native Client 11.0 or later

---

## Dimensions

### 1. Date Dimension
**Source Table**: `dbo.dim_date`
**Type**: Time Dimension

**Attributes**:
- date_key (Key Attribute)
- full_date
- day_number
- month_number
- month_name
- quarter_number
- year_number
- week_of_year

**Hierarchy: Date Hierarchy** ⭐ (REQUIRED)
```
Level 1: Year (year_number)
  └─ Level 2: Quarter (quarter_number)
      └─ Level 3: Month (month_name)
          └─ Level 4: Day (day_number/full_date)
```

**Attribute Relationships**:
- day_number → month_number
- month_number → quarter_number
- quarter_number → year_number

---

### 2. Vehicle Dimension
**Source Table**: `dbo.dim_vehicle`

**Attributes**:
- vehicle_key (Key Attribute)
- vehicle_nk
- car_make
- car_model
- car_year
- vehicle_category

**Hierarchy: Vehicle Hierarchy** (Optional but recommended)
```
Level 1: Car Make (car_make)
  └─ Level 2: Car Model (car_model)
      └─ Level 3: Car Year (car_year)
```

**Attribute Relationships**:
- car_year → car_model
- car_model → car_make

---

### 3. Customer Dimension
**Source Table**: `dbo.dim_customer`

**Attributes**:
- customer_key (Key Attribute)
- customer_nk
- customer_name
- region
- is_current (filter attribute)

**Note**: Only use current customers (is_current = 1) for analysis

**Hierarchy: Customer Hierarchy** (Optional)
```
Level 1: Region (region)
  └─ Level 2: Customer (customer_name)
```

**Named Query (for current customers only)**:
```sql
SELECT 
    customer_key,
    customer_nk,
    customer_name,
    region
FROM dbo.dim_customer
WHERE is_current = 1
```

---

## Fact Table / Measure Group

### Measure Group: Sales
**Source Table**: `dbo.fact_sales`
**Granularity**: One row per sales transaction

**Dimensions Connected**:
- Date Dimension (via date_key)
- Vehicle Dimension (via vehicle_key)
- Customer Dimension (via customer_key)

---

## Measures

### 1. Sale Amount (SUM)
- **Source Column**: sale_amount
- **Aggregation**: Sum
- **Format**: Currency ($)
- **Description**: Total revenue from car sales

### 2. Commission Amount (SUM)
- **Source Column**: commission_amount
- **Aggregation**: Sum
- **Format**: Currency ($)
- **Description**: Total commissions earned

### 3. Transaction Count (COUNT)
- **Source Column**: sales_fact_key
- **Aggregation**: Count
- **Format**: Number (#,##0)
- **Description**: Number of sales transactions

### 4. Average Sale Amount (CALCULATED)
- **Formula**: [Sale Amount] / [Transaction Count]
- **Format**: Currency ($)
- **Description**: Average sale price per transaction

### 5. Average Processing Time (AVG)
- **Source Column**: txn_process_time_hours
- **Aggregation**: Average
- **Format**: Decimal (0.00)
- **Description**: Average transaction processing time in hours

### 6. Commission Rate (CALCULATED)
- **Formula**: [Commission Amount] / [Sale Amount]
- **Format**: Percentage (0.00%)
- **Description**: Commission as percentage of sales

---

## Cube Structure Summary

```
CarSalesCube
│
├─ Dimensions
│   ├─ Date
│   │   └─ Hierarchy: Year → Quarter → Month → Day ⭐
│   ├─ Vehicle
│   │   └─ Hierarchy: Make → Model → Year
│   └─ Customer
│       └─ Hierarchy: Region → Customer Name
│
└─ Measure Groups
    └─ Sales
        ├─ Sale Amount
        ├─ Commission Amount
        ├─ Transaction Count
        ├─ Average Sale Amount (Calculated)
        ├─ Average Processing Time
        └─ Commission Rate (Calculated)
```

---

## KPIs (Optional - for advanced features)

### 1. Sales Target KPI
- **Goal**: $50,000,000 annual sales
- **Status Indicator**: 
  - Red: < 80% of goal
  - Yellow: 80-100% of goal
  - Green: > 100% of goal

### 2. Commission Efficiency KPI
- **Goal**: 12% average commission rate
- **Status**: Actual vs. Target commission percentage

---

## Aggregations and Partitions

### Partitions (for large data - optional)
- Partition by Year (2022, 2023, 2024, 2025, 2026)
- Improves query performance

### Aggregation Design
- Pre-calculate aggregations at:
  - Year level
  - Quarter level
  - Month level
  - Year + Vehicle Make
  - Year + Region

---

## SSAS Project Structure

```
CarSalesCube (Project)
│
├─ Data Sources
│   └─ CarSalesDW.ds
│
├─ Data Source Views
│   └─ CarSalesDW.dsv
│       ├─ dim_date
│       ├─ dim_vehicle
│       ├─ dim_customer (filtered view)
│       └─ fact_sales
│
├─ Dimensions
│   ├─ Date.dim
│   ├─ Vehicle.dim
│   └─ Customer.dim
│
└─ Cubes
    └─ CarSales.cube
        ├─ Cube Dimensions (Date, Vehicle, Customer)
        ├─ Measure Groups (Sales)
        └─ Calculations (MDX)
```

---

## Step-by-Step Creation Process

### Phase 1: Create Project
1. Open Visual Studio 2022
2. File → New → Project
3. Select "Analysis Services Multidimensional Project"
4. Name: CarSalesCube
5. Location: Choose assignment folder

### Phase 2: Data Source
1. Right-click "Data Sources" → New Data Source
2. Connection Manager:
   - Server: localhost
   - Database: CarSalesDW
   - Windows Authentication
3. Test connection → Next → Finish

### Phase 3: Data Source View
1. Right-click "Data Source Views" → New Data Source View
2. Add tables:
   - dbo.dim_date
   - dbo.dim_vehicle
   - dbo.dim_customer
   - dbo.fact_sales
3. Verify relationships are detected
4. Create Named Query for dim_customer (current only)

### Phase 4: Create Dimensions
1. Right-click "Dimensions" → New Dimension (for each)
2. Date Dimension:
   - Key: date_key
   - Create Date Hierarchy
   - Set attribute relationships
3. Vehicle Dimension:
   - Key: vehicle_key
   - Create Vehicle Hierarchy (optional)
4. Customer Dimension:
   - Key: customer_key
   - Use named query (current customers)

### Phase 5: Create Cube
1. Right-click "Cubes" → New Cube
2. Use existing tables
3. Select fact_sales
4. Select measures (all numeric columns)
5. Add dimensions to cube
6. Review and finish

### Phase 6: Configure Cube
1. Define dimension relationships
2. Create calculated measures
3. Configure measure formatting
4. Build hierarchies
5. Set aggregation functions

### Phase 7: Deploy
1. Right-click project → Properties
2. Set Deployment Server (localhost)
3. Right-click project → Deploy
4. Process the cube (Full Process)
5. Browse cube to verify

---

## MDX Calculations (Advanced)

### Year-over-Year Growth
```mdx
WITH MEMBER [Measures].[YoY Growth] AS
  ([Measures].[Sale Amount] - 
   ([Measures].[Sale Amount], ParallelPeriod([Date].[Date Hierarchy].[Year], 1)))
  /
  ([Measures].[Sale Amount], ParallelPeriod([Date].[Date Hierarchy].[Year], 1))
FORMAT_STRING = "Percent"
```

### Moving Average
```mdx
WITH MEMBER [Measures].[3 Month Moving Avg] AS
  Avg(
    [Date].[Date Hierarchy].CurrentMember.Lag(2):
    [Date].[Date Hierarchy].CurrentMember,
    [Measures].[Sale Amount]
  )
FORMAT_STRING = "Currency"
```

---

## Expected Output for Assignment

### Screenshots to Capture:
1. Data Source configuration
2. Data Source View with all tables
3. Date dimension with hierarchy
4. Vehicle dimension attributes
5. Customer dimension setup
6. Cube structure in designer
7. Dimension usage matrix
8. Measure definitions
9. Deployment success message
10. Cube browser showing sample data

### Documentation to Write:
- Step-by-step process followed
- Design decisions (why certain hierarchies)
- Challenges encountered and solutions
- Cube performance considerations

---

## Verification Queries (MDX)

### Test 1: Total Sales by Year
```mdx
SELECT 
  {[Measures].[Sale Amount], [Measures].[Transaction Count]} ON COLUMNS,
  [Date].[Date Hierarchy].[Year].MEMBERS ON ROWS
FROM [CarSalesCube]
```

### Test 2: Sales by Make and Year
```mdx
SELECT 
  [Date].[Date Hierarchy].[Year].MEMBERS ON COLUMNS,
  [Vehicle].[Car Make].[Car Make].MEMBERS ON ROWS
FROM [CarSalesCube]
WHERE [Measures].[Sale Amount]
```

### Test 3: Top 10 Customers by Sales
```mdx
SELECT 
  {[Measures].[Sale Amount], [Measures].[Commission Amount]} ON COLUMNS,
  TOPCOUNT([Customer].[Customer Name].[Customer Name].MEMBERS, 10, [Measures].[Sale Amount]) ON ROWS
FROM [CarSalesCube]
```

---

## Troubleshooting

**Issue**: Dimension relationships not detected
**Solution**: Manually configure in Data Source View, ensure FK constraints exist in DB

**Issue**: Cube deployment fails
**Solution**: Check SSAS service is running, verify connection string, ensure user has permissions

**Issue**: Hierarchy doesn't work
**Solution**: Configure attribute relationships in dimension designer

**Issue**: Measures showing wrong values
**Solution**: Check aggregation function, verify data types, check for NULL handling

---

*Ready for Step 2 Implementation*
*Estimated Time: 2-3 hours*
