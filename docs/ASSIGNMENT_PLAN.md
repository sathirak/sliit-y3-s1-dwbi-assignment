# IT3021 - DWBI Assignment 2 - Implementation Plan

## Assignment Overview
- **Course**: IT3021 Data Warehousing and Business Intelligence
- **Due Date**: 03.04.2026 (6 days remaining)
- **Total Marks**: 100 marks (20% of final grade)
- **Submission**: Zip file with organized folder structure

---

## Tasks Breakdown & Implementation Plan

### ✅ PREREQUISITE: Assignment 1 Data Warehouse
**Status**: PARTIALLY COMPLETE
- We have the data warehouse SQL scripts (task4_dw_schema.sql, task5_etl_sql_support.sql)
- We have the ETL project (CarSalesETL SSIS packages)
- We have the source data files (CSV files)
- **Next**: Need to verify/complete the data warehouse and load data

---

### 📊 STEP 1: Data Source Documentation (5 marks)
**What to do**:
- Document the data warehouse schema from Assignment 1
- Create/update ER diagrams
- Describe tables, relationships, and data structure

**Files to create**:
- `/docs/DataWarehouse_Schema.md` - Text documentation
- `/docs/ER_Diagram.png` - ER diagram (can generate from SSMS)

**Estimated time**: 1 hour

---

### 🧊 STEP 2: SSAS Cube Implementation (20 marks)
**What to do**:
- Create new SSAS project in Visual Studio
- Connect to the data warehouse
- Design cube with:
  - Measures from fact table(s)
  - Dimensions (customer, time, product, etc.)
  - **At least 1 hierarchy** (e.g., Date: Year → Quarter → Month)
- Deploy cube to SSAS server

**Files to create**:
- `/ssas/CubeProject_ITXXXXXXXX/` - Complete SSAS solution
- `/docs/SSAS_Implementation.md` - Documentation with screenshots

**Estimated time**: 3-4 hours

---

### 📈 STEP 3: OLAP Operations in Excel (25 marks)
**What to do**:
- Connect Excel to SSAS Cube
- Create Pivot Tables and Charts demonstrating:
  1. **Roll-up**: Aggregate sales by year instead of month
  2. **Drill-Down**: Expand year to see months/days
  3. **Slice**: Filter to show only specific year or region
  4. **Dice**: Filter multiple dimensions (e.g., specific years AND regions)
  5. **Pivot**: Swap rows/columns in pivot table

**Files to create**:
- `/excel/OLAP_Operations_ITXXXXXXXX.xlsx` - Excel workbook
- `/docs/OLAP_Demonstrations.md` - Documentation with screenshots

**Estimated time**: 2-3 hours

---

### 📊 STEP 4: PowerBI Reports (50 marks) - MAIN COMPONENT
**What to do**:
Create 4 separate PowerBI reports and publish to PowerBI Service

#### Report 1: Matrix Visual Report
- Matrix table with row/column groupings
- Show hierarchical data (e.g., products grouped by category)
- Include totals and subtotals

#### Report 2: Cascading Filters Report
- **Critical**: Implement cascading slicers
  - Slicer 1: Select Year → Slicer 2 shows only Quarters in that Year
  - Or: Select Region → Shows only Cities in that Region
- Multiple visuals (bar charts, line charts, KPI cards)
- Demonstrate dynamic filtering

#### Report 3: Drill-Down Report
- Hierarchical navigation (Year → Quarter → Month → Day)
- Allow users to click down through levels
- Visual changes as user drills down

#### Report 4: Drill-Through Report
- Summary page with overview visuals
- Detail page with granular data
- Right-click on summary visual → "Drill through" → See details
- Context filters automatically applied

**Files to create**:
- `/powerbi/Report1_Matrix_ITXXXXXXXX.pbix`
- `/powerbi/Report2_CascadingFilters_ITXXXXXXXX.pbix`
- `/powerbi/Report3_DrillDown_ITXXXXXXXX.pbix`
- `/powerbi/Report4_DrillThrough_ITXXXXXXXX.pbix`
- `/docs/PowerBI_Reports.md` - Comprehensive documentation

**PowerBI Service**:
- Publish all 4 reports online
- Document workspace URLs
- Prepare for online demonstration

**Estimated time**: 6-8 hours (largest component)

---

## Submission Structure

```
DWBI_Assignment_2_Answer_ITXXXXXXXX/
├── 1_DataWarehouse_ITXXXXXXXX/
│   ├── CarSalesDW.bak               (Database backup)
│   └── Schema_Scripts.sql           (DDL scripts)
│
├── 2_CubeProject_ITXXXXXXXX/
│   ├── CarSalesCube.sln             (SSAS solution)
│   ├── CarSalesCube.dwproj          (SSAS project)
│   └── [All SSAS cube files]
│
├── 3_Excel_ITXXXXXXXX/
│   └── OLAP_Operations.xlsx         (Pivot tables/charts)
│
├── 4_PowerBIReports_ITXXXXXXXX/
│   ├── Report1_Matrix.pbix
│   ├── Report2_CascadingFilters.pbix
│   ├── Report3_DrillDown.pbix
│   └── Report4_DrillThrough.pbix
│
└── 5_Document_ITXXXXXXXX/
    └── DWBI_Assignment2_Report.pdf  (Complete documentation)
```

---

## Documentation Requirements

The PDF report must include:

### Section 1: Data Warehouse Overview
- Schema description
- ER diagrams
- Table structures
- Relationships

### Section 2: SSAS Cube Implementation
- Step-by-step screenshots
- Cube structure
- Measures and dimensions
- Hierarchy design
- Deployment process

### Section 3: OLAP Operations
- Screenshots of each operation
- Explanation of Roll-up, Drill-Down, Slice, Dice, Pivot
- Excel formulas (if used)

### Section 4: PowerBI Reports
- Report 1: Matrix visual design
- Report 2: Cascading filter implementation (with DAX if needed)
- Report 3: Drill-down hierarchy setup
- Report 4: Drill-through configuration
- Data modeling approach
- DAX formulas used
- PowerBI Service URLs

---

## Implementation Timeline

**Day 1** (Today):
- ✅ Organize existing files
- ✅ Understand assignment requirements
- 🔲 Verify data warehouse setup
- 🔲 Load data using ETL

**Day 2**:
- 🔲 Complete SSAS cube implementation
- 🔲 Deploy cube
- 🔲 Test cube in SSMS

**Day 3**:
- 🔲 Excel OLAP operations
- 🔲 Create all pivot tables/charts
- 🔲 Document with screenshots

**Day 4-5**:
- 🔲 PowerBI Report 1 (Matrix)
- 🔲 PowerBI Report 2 (Cascading Filters)
- 🔲 PowerBI Report 3 (Drill-Down)
- 🔲 PowerBI Report 4 (Drill-Through)
- 🔲 Publish to PowerBI Service

**Day 6** (Final):
- 🔲 Complete PDF documentation
- 🔲 Organize all files into submission structure
- 🔲 Create final ZIP file
- 🔲 Submit before deadline

---

## Technologies & Software Required

- ✅ SQL Server (installed and running)
- ✅ Visual Studio with SSIS
- 🔲 SQL Server Data Tools (SSDT) for SSAS
- 🔲 SQL Server Analysis Services (SSAS)
- 🔲 Microsoft Excel 2016+
- 🔲 PowerBI Desktop (free download)
- 🔲 PowerBI Service account (free signup)

---

## Critical Success Factors

1. **Data Warehouse Must Be Complete**: Assignment 1 is prerequisite
2. **Hierarchy in Cube**: At least 1 hierarchy required
3. **All 5 OLAP Operations**: Must demonstrate all
4. **Cascading Filters**: Critical feature in PowerBI Report 2
5. **Online Demonstration**: PowerBI reports must be published online
6. **Complete Documentation**: Screenshots for every step

---

## Next Steps

1. Verify the data warehouse is properly set up
2. Run ETL to load data
3. Install SSDT and configure SSAS
4. Start with SSAS cube creation
5. Progress through Excel and PowerBI tasks
6. Document everything with screenshots as we go
