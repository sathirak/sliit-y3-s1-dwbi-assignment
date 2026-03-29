# Step 4 - Power BI Reports (50 Marks)

Create 4 reports and publish to Power BI Service.

## Data Source
Use either:
- SQL Server: `localhost`, database `CarSalesDW`
- or SSAS cube: `localhost`, database `CarSalesCube`, cube `CarSales`

---

## Report 1: Matrix Visual
- Visual: Matrix
- Rows: Year, Quarter, Month
- Columns: Car Make (or Region)
- Values: Sale Amount, Commission Amount
- Must show totals/subtotals

Save as: `Report1_Matrix_ITXXXXXXXX.pbix`

---

## Report 2: Cascading Filters
- Add slicer 1: Region
- Add slicer 2: Customer Name (should filter based on Region)
- Add visuals: bar chart + line chart + KPI card

Save as: `Report2_CascadingFilters_ITXXXXXXXX.pbix`

---

## Report 3: Drill-Down
- Build hierarchy: Year -> Quarter -> Month
- Use chart with drill mode enabled
- Show navigation through levels

Save as: `Report3_DrillDown_ITXXXXXXXX.pbix`

---

## Report 4: Drill-Through
- Page 1: Summary visuals (Year/Make/Region)
- Page 2: Detail page with Drill-through filter (e.g., Customer or Vehicle)
- Right-click data point -> Drill through -> Detail page

Save as: `Report4_DrillThrough_ITXXXXXXXX.pbix`

---

## Publish to Power BI Service
For each report:
1. Home -> Publish
2. Select workspace (My Workspace)
3. Open in app.powerbi.com
4. Copy report URL for documentation

---

## Screenshot Checklist
Capture screenshots for:
- Each report design page
- Slicer interactions (for cascading)
- Drill-down action
- Drill-through action
- Publish success + online URL page

---

## Deliverables Folder
Store in:
`Assignment-2\powerbi\`

Files expected:
- Report1_Matrix_ITXXXXXXXX.pbix
- Report2_CascadingFilters_ITXXXXXXXX.pbix
- Report3_DrillDown_ITXXXXXXXX.pbix
- Report4_DrillThrough_ITXXXXXXXX.pbix
- REPORT_URLS.txt (4 Power BI service links)
