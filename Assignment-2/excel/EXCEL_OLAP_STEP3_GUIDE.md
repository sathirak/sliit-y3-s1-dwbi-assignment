# Step 3 - Excel OLAP Operations (25 Marks)

## Goal
Demonstrate all 5 OLAP operations using the `CarSalesCube` in Excel:
- Roll-up
- Drill-Down
- Slice
- Dice
- Pivot

---

## A) Connect Excel to SSAS Cube

1. Open Excel (blank workbook)
2. Go to **Data** tab
3. Click **Get Data** -> **From Database** -> **From Analysis Services**
4. Server: `localhost`
5. Select database: `CarSalesCube`
6. Select cube/model: `CarSales`
7. Load as **PivotTable Report** in a new worksheet

Create 5 sheets and name them:
- `01_RollUp`
- `02_DrillDown`
- `03_Slice`
- `04_Dice`
- `05_Pivot`

---

## B) Operation 1: Roll-up

**What to show:** Aggregated sales at higher level.

1. On sheet `01_RollUp`
2. Rows: `Date` hierarchy -> **Year**
3. Values: `Measures` -> **Sale Amount**
4. Optional Filter: none

✅ Expected result: One sales total per year (e.g., 2022, 2023, ...)

📸 Screenshot: Pivot table + field list visible.

---

## C) Operation 2: Drill-Down

**What to show:** Expand Year into Quarter/Month.

1. Copy roll-up pivot to `02_DrillDown`
2. Keep Rows = Date hierarchy
3. Click `+` next to one Year to expand to Quarter
4. Expand again to Month

✅ Expected result: Year -> Quarter -> Month hierarchy visible.

📸 Screenshot: Expanded hierarchy with multi-level rows.

---

## D) Operation 3: Slice

**What to show:** Filter by one dimension.

1. On `03_Slice`
2. Rows: Year (Date hierarchy)
3. Values: Sale Amount
4. Add one filter/slicer:
   - Example: `Customer -> Region`
5. Select a single region (e.g., West)

✅ Expected result: Sales shown only for that selected region.

📸 Screenshot: Pivot + selected slicer/filter.

---

## E) Operation 4: Dice

**What to show:** Filter by multiple dimensions.

1. On `04_Dice`
2. Rows: Year or Month
3. Values: Sale Amount
4. Add 2+ filters/slicers:
   - Region = West
   - Car Make = Ford
   - (Optional) Year = 2024

✅ Expected result: Data for intersection of multiple filters.

📸 Screenshot: Multiple filters selected + reduced dataset.

---

## F) Operation 5: Pivot

**What to show:** Rotate dimensions between rows and columns.

1. On `05_Pivot`
2. Start with:
   - Rows: Year
   - Columns: Car Make
   - Values: Sale Amount
3. Then swap:
   - Rows: Car Make
   - Columns: Year

✅ Expected result: Same measure view, but axes rotated.

📸 Screenshot: One orientation or both before/after.

---

## Required deliverables for Step 3

Save workbook as:
`Assignment-2\excel\OLAP_Operations_ITXXXXXXXX.xlsx`

Take at least 5 screenshots (one per operation), and keep them for final PDF report.

---

## Quick quality checklist

- [ ] Connected to `CarSalesCube` successfully
- [ ] Sale Amount measure used in all operations
- [ ] 5 operations demonstrated clearly
- [ ] Screenshots captured with filter states visible
- [ ] Workbook saved in Assignment-2/excel

---

When done, tell Copilot: "Excel Step 3 done" and we will generate your documentation text + start PowerBI Step 4.
