# Step 3 (Excel OLAP) - Beginner Click-by-Click Guide

You said you are new to this, so follow this **exactly**.

Goal: Show these 5 operations in Excel:
1. Roll-up
2. Drill-Down
3. Slice
4. Dice
5. Pivot

---

## 0) Before you start

- Make sure SSAS cube works (you already saw Sale Amount number, so good).
- Keep SSMS closed while doing Excel if your PC is slow.

---

## 1) Open Excel and connect to cube

1. Open **Microsoft Excel**.
2. Click **Blank workbook**.
3. Go to top tab **Data**.
4. Click **Get Data** (left side).
5. Click **From Database**.
6. Click **From Analysis Services**.
7. In Server box, type: `localhost`
8. Click **Next**.
9. Choose database: **CarSalesCube**
10. Choose cube/model: **CarSales**
11. Click **Finish**.
12. In Import Data window:
    - Select **PivotTable Report**
    - Select **New Worksheet**
13. Click **OK**.

Now you should see:
- Empty PivotTable on left
- **PivotTable Fields** pane on right

If right pane is missing:
- Click anywhere inside pivot table
- Go to **PivotTable Analyze** tab
- Click **Field List**

---

## 2) Create required worksheet names

At bottom tabs, create/rename sheets exactly:
- `01_RollUp`
- `02_DrillDown`
- `03_Slice`
- `04_Dice`
- `05_Pivot`

Tip:
- Right-click sheet tab -> Rename
- Copy first pivot sheet 4 times (right-click tab -> Move or Copy -> Create a copy)

---

## 3) Understand 4 Pivot areas (important)

In right pane (PivotTable Fields), you’ll see 4 boxes:
- **Filters**
- **Columns**
- **Rows**
- **Values**

You drag fields into these boxes.

---

## 4) Operation 1: Roll-up (Sheet `01_RollUp`)

### What this means
Show total sales at high level (Year only).

### Exact steps
1. Click sheet `01_RollUp`.
2. In field list, find Date hierarchy (Year/Quarter/Month or similar).
3. Drag **Year** into **Rows** box.
4. In Measures, drag **Sale Amount** into **Values** box.
5. Remove anything else from Rows/Columns/Filters.

### Expected output
- One row per year
- One total sale amount per year

📸 Take screenshot: full pivot + right field pane.

---

## 5) Operation 2: Drill-Down (Sheet `02_DrillDown`)

### What this means
Go from Year to deeper level (Quarter, Month).

### Exact steps
1. Copy `01_RollUp` pivot to `02_DrillDown` (or recreate same).
2. In rows, ensure Date hierarchy includes:
   - Year
   - Quarter
   - Month
3. In pivot table, click **+** beside a Year.
4. You should now see Quarter rows under that Year.
5. Click **+** beside a Quarter to see Month.

### Expected output
- Tree style data: Year -> Quarter -> Month

📸 Take screenshot with expanded Year and Quarter.

---

## 6) Operation 3: Slice (Sheet `03_Slice`)

### What this means
Filter using **one** dimension only.

### Exact steps
1. Click sheet `03_Slice`.
2. Keep:
   - Rows: Year
   - Values: Sale Amount
3. Add one filter:
   - Drag **Region** into **Filters** box.
4. On pivot table top, open Region dropdown.
5. Select only one region (example: `West`).
6. Click OK.

### Expected output
- Sales now shown only for one selected region.

📸 Screenshot must show selected Region value.

---

## 7) Operation 4: Dice (Sheet `04_Dice`)

### What this means
Filter using **multiple** dimensions at same time.

### Exact steps
1. Click sheet `04_Dice`.
2. Keep:
   - Rows: Year (or Month)
   - Values: Sale Amount
3. Add multiple filters:
   - Region -> Filters
   - Car Make -> Filters
   - (Optional) Year -> Filters
4. Select:
   - Region = one value (ex: West)
   - Car Make = one value (ex: Ford)
   - Year = one value (optional)

### Expected output
- Data becomes smaller (intersection of filters).

📸 Screenshot must show all selected filters.

---

## 8) Operation 5: Pivot (Sheet `05_Pivot`)

### What this means
Rotate axes (swap Rows and Columns).

### Exact steps
1. Click sheet `05_Pivot`.
2. First layout:
   - Rows: Year
   - Columns: Car Make
   - Values: Sale Amount
3. Screenshot this first layout.
4. Now swap:
   - Move Car Make to Rows
   - Move Year to Columns
5. Screenshot second layout.

### Expected output
- Same data view, but direction changed (rotated).

📸 At least one screenshot; better to keep both before/after.

---

## 9) Save workbook

Save to:

`C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\Assignment-2\excel\OLAP_Operations_ITXXXXXXXX.xlsx`

Replace `ITXXXXXXXX` with your student ID.

---

## 10) What to submit later from Step 3

- Excel file above
- 5+ screenshots (one per operation) for final PDF report

---

## Troubleshooting (quick)

### I can’t see field list
- Click pivot table -> PivotTable Analyze -> Field List

### I can’t find Sale Amount
- Expand `Measures`
- Look for `Sale Amount` or similar name

### Everything is blank
- Check connection:
  - Data -> Queries & Connections
  - Refresh All

### Too slow
- Close SSMS and Visual Studio while using Excel

---

When done, message:
**“Excel Step 3 done”**
and I’ll generate your exact documentation text for report.
