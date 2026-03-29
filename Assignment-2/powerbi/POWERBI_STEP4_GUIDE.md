# Step 4 (Power BI) - Beginner Click-by-Click Guide

You said you are new, so this is written as exact actions.

You must create 4 reports:
1. Matrix Report
2. Cascading Filters Report
3. Drill-Down Report
4. Drill-Through Report

---

## 0) Open Power BI and load data (do this once)

1. Open **Power BI Desktop**.
2. Click **Get data**.
3. Choose **SQL Server**.
4. Server: `localhost`
5. Database: `CarSalesDW`
6. Data Connectivity mode: **Import**
7. Click **OK**
8. Authentication: **Windows**
9. Click **Connect**
10. In Navigator, select:
    - `fact_sales`
    - `dim_date`
    - `dim_vehicle`
    - `dim_customer`
11. Click **Load**

Now check relationships:
1. Click left icon **Model**.
2. Ensure these relationships exist:
   - fact_sales.date_key -> dim_date.date_key
   - fact_sales.vehicle_key -> dim_vehicle.vehicle_key
   - fact_sales.customer_key -> dim_customer.customer_key
3. If missing:
   - Drag matching key from one table to the other.

Create measure:
1. In Data/Model view, select table `fact_sales`.
2. Click **New measure**.
3. Enter:
```DAX
Total Sales = SUM(fact_sales[sale_amount])
```
4. Press Enter.

Optional second measure:
```DAX
Total Commission = SUM(fact_sales[commission_amount])
```

---

## 1) Report 1 - Matrix Visual

### Create
1. Bottom tabs, rename page to `Report1_Matrix`.
2. In Visualizations, click **Matrix** icon.
3. Drag fields:
   - Rows: `dim_date[year_number]`, then `dim_date[quarter_number]`, then `dim_date[month_number]`
   - Columns: `dim_vehicle[car_make]`
   - Values: `Total Sales`, `Total Commission`
4. In matrix visual settings, keep totals/subtotals ON.

### Save
- File -> Save As:
`Assignment-2\powerbi\Report1_Matrix_ITXXXXXXXX.pbix`

📸 Screenshot: full matrix with hierarchy and totals.

---

## 2) Report 2 - Cascading Filters

### Create
1. Add new page (`+`) and rename `Report2_CascadingFilters`.
2. Add **Slicer** visual (first slicer):
   - Field: `dim_customer[region]`
3. Add second **Slicer**:
   - Field: `dim_customer[customer_name]`

This becomes cascading because customer is related to region table:
- Select region in slicer 1
- Slicer 2 should show only customers from that region

4. Add visuals:
   - Clustered column chart:
     - Axis: `dim_vehicle[car_make]`
     - Values: `Total Sales`
   - Line chart:
     - Axis: `dim_date[month_number]`
     - Values: `Total Sales`
   - Card:
     - Field: `Total Sales`

### Test cascading
1. Click one region in slicer 1.
2. Check slicer 2 list changes (reduced customer list).

### Save
`Assignment-2\powerbi\Report2_CascadingFilters_ITXXXXXXXX.pbix`

📸 Screenshot: both slicers + changed customer list.

---

## 3) Report 3 - Drill-Down

### Create
1. Add new page and rename `Report3_DrillDown`.
2. Add **Clustered column chart**.
3. Build date hierarchy on axis:
   - Axis: `year_number`, `quarter_number`, `month_number` (in this order)
4. Values: `Total Sales`
5. On chart top, enable drill mode:
   - Click drill icon (down arrow)
6. Click a year bar to drill into quarter, then month.

### Save
`Assignment-2\powerbi\Report3_DrillDown_ITXXXXXXXX.pbix`

📸 Screenshot: chart at Year level and drilled Quarter/Month level.

---

## 4) Report 4 - Drill-Through

### Create summary page
1. Add page, rename `Report4_Summary`.
2. Add bar chart:
   - Axis: `dim_vehicle[car_make]`
   - Values: `Total Sales`

### Create detail page
1. Add new page, rename `Report4_Detail`.
2. In Visualizations pane (bottom area), find **Drill-through** field well.
3. Drag `dim_vehicle[car_make]` into Drill-through field.
4. Add table visual with details:
   - customer_name
   - sale_amount
   - commission_amount
   - year_number

### Test drill-through
1. Go back to `Report4_Summary`.
2. Right-click one bar (car make).
3. Choose **Drill through -> Report4_Detail**.
4. Detail page should open filtered to selected make.

### Save
`Assignment-2\powerbi\Report4_DrillThrough_ITXXXXXXXX.pbix`

📸 Screenshot: right-click drill-through menu + filtered detail page.

---

## 5) Publish each report to Power BI Service

For each PBIX:
1. Open report file
2. Click **Publish** (Home tab)
3. Choose **My Workspace**
4. Wait success message
5. Click link **Open in Power BI**
6. Copy URL from browser
7. Paste into:
`Assignment-2\powerbi\REPORT_URLS.txt`

---

## 6) Final checklist for Step 4

- [ ] Report1_Matrix_ITXXXXXXXX.pbix created
- [ ] Report2_CascadingFilters_ITXXXXXXXX.pbix created
- [ ] Report3_DrillDown_ITXXXXXXXX.pbix created
- [ ] Report4_DrillThrough_ITXXXXXXXX.pbix created
- [ ] All 4 published online
- [ ] 4 URLs saved in REPORT_URLS.txt
- [ ] Screenshots captured for each report

---

## If you get stuck

Send me:
- Which report number you are on
- What button/step you cannot find
- Screenshot text of error (if any)

I’ll give exact next clicks.
