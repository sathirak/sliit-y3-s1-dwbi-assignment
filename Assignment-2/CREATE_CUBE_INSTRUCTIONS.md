# Creating SSAS Cube - Step-by-Step Instructions

## Prerequisites Check
- ✅ Visual Studio 2022 Launched
- ✅ CarSalesDW database with 2.5M transactions
- ⏳ SSDT Extension for Analysis Services (installing if needed)

---

## STEP 1: Create New Analysis Services Project

### In Visual Studio (NOW):

1. **Wait for Visual Studio to fully load**

2. **Create New Project**:
   - Click **File** → **New** → **Project**
   - Or click **Create a new project** on start page

3. **Search for Analysis Services**:
   - In the search box, type: **"Analysis Services"**
   - Look for: **"Analysis Services Multidimensional Project"**
   
   **⚠️ IF YOU DON'T SEE IT**:
   - The SSDT extension isn't installed yet
   - Go to **Extensions** → **Manage Extensions**
   - Click **Online** tab
   - Search: **"Analysis Services"**
   - Find: **"Microsoft Analysis Services Projects 2022"** (by Microsoft)
   - Click **Download**
   - **Close Visual Studio** to install
   - VSIX Installer will run
   - **Restart Visual Studio** after installation
   - Then come back to Step 1

4. **Configure Project**:
   - **Project name**: CarSalesCube
   - **Location**: `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\Assignment-2\ssas`
   - **Solution name**: CarSalesCube
   - Click **Create**

---

## STEP 2: Add Data Source

### In Solution Explorer (right panel):

1. **Right-click "Data Sources"** → **New Data Source...**

2. **Welcome screen** → Click **Next**

3. **Select how to define the connection**:
   - Click **New...** button

4. **Connection Manager dialog** (**Recommended: ADO.NET provider**):
   - If provider options appear, choose **.NET Framework Data Provider for SQL Server (SqlClient / ADO.NET)**
   - **Server name**: `localhost` (or `.` or `(local)`)
   - **Authentication**: Windows Authentication
   - **Select database**: `CarSalesDW`
   - Click **Test Connection** → Should say "Test connection succeeded"
   - Click **OK**

   If test fails, use this connection string:
   ```text
   Data Source=localhost;Initial Catalog=CarSalesDW;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;
   ```

5. **Impersonation Information**:
   - Select: **Use the service account**
   - Click **Next**

6. **Completing the Wizard**:
   - Data source name: **CarSalesDW**
   - Click **Finish**

✅ **Result**: You should see "CarSalesDW.ds" in Solution Explorer under Data Sources

---

## STEP 3: Create Data Source View

### Add Tables and Relationships:

1. **Right-click "Data Source Views"** → **New Data Source View...**

2. **Welcome** → Click **Next**

3. **Select a Data Source**:
   - Select **CarSalesDW** 
   - Click **Next**

4. **Select Tables and Views**:
   - From **Available objects**, move these to **Included objects**:
     - ✅ `dbo.dim_date`
     - ✅ `dbo.dim_vehicle`
     - ✅ `dbo.dim_customer`
     - ✅ `dbo.fact_sales`
   - Click the **>** button or double-click each table
   - Click **Next**

5. **Completing the Wizard**:
   - Name: **CarSalesDW**
   - Click **Finish**

6. **Verify Relationships** (DSV Designer opens):
   - You should see a diagram with 4 tables
   - Lines between tables show FK relationships
   - **fact_sales** connects to all 3 dimensions

   **If relationships are missing**:
   - Right-click in diagram → **New Relationship**
   - Connect fact_sales to each dimension table

7. **Create Named Query for dim_customer** (IMPORTANT):
   - We only want CURRENT customers
   - Right-click on `dim_customer` table → **Replace Table** → **With New Named Query**
   - Name: `dim_customer_current`
   - SQL Query:
   ```sql
   SELECT 
       customer_key,
       customer_nk,
       customer_name,
       region,
       is_current
   FROM dbo.dim_customer
   WHERE is_current = 1
   ```
   - Click **OK**

8. **Save** (Ctrl+S)

✅ **Result**: CarSalesDW.dsv created with 4 tables and relationships

---

## STEP 4: Create Dimensions

### A. Date Dimension (CRITICAL - Has Required Hierarchy)

1. **Right-click "Dimensions"** → **New Dimension...**

2. **Welcome** → Click **Next**

3. **Select Creation Method**:
   - Choose: **Use an existing table**
   - Click **Next**

4. **Specify Source Information**:
   - **Main table**: `dbo.dim_date`
   - **Key columns**: `date_key` (should be auto-selected)
   - **Name column**: `full_date`
   - Click **Next**

5. **Select Dimension Attributes**:
   - Check ALL these attributes:
     - ✅ date_key (Key)
     - ✅ full_date
     - ✅ day_number
     - ✅ month_number
     - ✅ month_name
     - ✅ quarter_number
     - ✅ year_number
     - ✅ week_of_year
   - Click **Next**

6. **Completing the Wizard**:
   - Dimension name: **Date**
   - Click **Finish**

7. **Create Date Hierarchy** ⭐ (REQUIRED FOR ASSIGNMENT):
   - Dimension designer opens
   - In **Attributes** pane, you see all attributes
   - In **Hierarchies** pane (middle), right-click → **New Hierarchy**
   - Name it: **Date Hierarchy**
   - **Drag attributes from left to hierarchy** in this order:
     1. `year_number` → Drag to **<new level>**
     2. `quarter_number` → Drag below year
     3. `month_name` → Drag below quarter
     4. `full_date` → Drag below month
   
   - Rename levels (click level, press F2):
     - Level 0: **Year**
     - Level 1: **Quarter**
     - Level 2: **Month**
     - Level 3: **Date**

8. **Set Attribute Relationships**:
   - Click **Attribute Relationships** tab
   - Create relationships (right-click → New Attribute Relationship):
     - `day_number` → `month_number`
     - `month_number` → `quarter_number`
     - `quarter_number` → `year_number`

9. **Save** (Ctrl+S)

✅ **Result**: Date dimension with 4-level hierarchy created

---

### B. Vehicle Dimension

1. **Right-click "Dimensions"** → **New Dimension...**

2. Follow wizard:
   - Use existing table: `dbo.dim_vehicle`
   - Key: `vehicle_key`
   - Name column: `car_make`
   - Select attributes:
     - ✅ vehicle_key
     - ✅ car_make
     - ✅ car_model
     - ✅ car_year
     - ✅ vehicle_category
   - Name: **Vehicle**
   - Click **Finish**

3. **(Optional) Create Vehicle Hierarchy**:
   - New Hierarchy: **Vehicle Hierarchy**
   - Levels:
     1. `car_make` (Make)
     2. `car_model` (Model)
     3. `car_year` (Year)

4. **Save**

✅ **Result**: Vehicle dimension created

---

### C. Customer Dimension

1. **Right-click "Dimensions"** → **New Dimension...**

2. Follow wizard:
   - Use existing table: `dbo.dim_customer_current` (the named query)
   - Key: `customer_key`
   - Name column: `customer_name`
   - Select attributes:
     - ✅ customer_key
     - ✅ customer_name
     - ✅ region
   - Name: **Customer**
   - Click **Finish**

3. **(Optional) Create Customer Hierarchy**:
   - New Hierarchy: **Customer Hierarchy**
   - Levels:
     1. `region` (Region)
     2. `customer_name` (Customer)

4. **Save**

✅ **Result**: Customer dimension created

---

## STEP 5: Create Cube

1. **Right-click "Cubes"** → **New Cube...**

2. **Welcome** → Click **Next**

3. **Select Creation Method**:
   - Choose: **Use existing tables**
   - Click **Next**

4. **Select Measure Group Tables**:
   - Check: ✅ `dbo.fact_sales`
   - Click **Next**

5. **Select Measures**:
   - The wizard auto-selects numeric columns as measures
   - Ensure these are checked:
     - ✅ Fact Sales Count (row count)
     - ✅ sale_amount
     - ✅ commission_amount
     - ✅ txn_process_time_hours
   - Uncheck any ID columns if selected
   - Click **Next**

6. **Select Existing Dimensions**:
   - Check ALL three dimensions:
     - ✅ Date
     - ✅ Vehicle
     - ✅ Customer
   - Click **Next**

7. **Completing the Wizard**:
   - Cube name: **CarSales**
   - Click **Finish**

✅ **Result**: Cube created with 3 dimensions and measures

---

## STEP 6: Configure Cube Measures

### In Cube Designer:

1. **Cube Structure** tab should be open

2. **In Measures pane**:
   - Expand **Fact Sales** measure group
   - For each measure, right-click → **Properties**:

   **sale_amount**:
   - Display Name: Sale Amount
   - Format String: Currency
   - Aggregation Function: Sum

   **commission_amount**:
   - Display Name: Commission Amount
   - Format String: Currency
   - Aggregation Function: Sum

   **txn_process_time_hours**:
   - Display Name: Avg Processing Time
   - Format String: #,##0.00
   - Aggregation Function: Average

   **Fact Sales Count**:
   - Display Name: Transaction Count
   - Format String: #,##0

3. **Add Calculated Measures** (Optional but impressive):
   - Click **Calculations** tab
   - Click **New Calculated Member** button (or Script → New Calculated Member)
   
   **Average Sale Amount**:
   ```mdx
   CREATE MEMBER CURRENTCUBE.[Measures].[Average Sale Amount] AS 
   [Measures].[Sale Amount] / [Measures].[Transaction Count],
   FORMAT_STRING = "Currency";
   ```

   **Commission Rate**:
   ```mdx
   CREATE MEMBER CURRENTCUBE.[Measures].[Commission Rate] AS 
   [Measures].[Commission Amount] / [Measures].[Sale Amount],
   FORMAT_STRING = "Percent";
   ```

4. **Save All** (Ctrl+Shift+S)

---

## STEP 7: Deploy and Process Cube

### Deploy to Analysis Services:

1. **Set Deployment Target**:
   - Right-click **CarSalesCube** project in Solution Explorer
   - Click **Properties**
   - Go to **Deployment**
   - **Server**: `localhost` (or your SSAS server/instance name)
   - **Database**: `CarSalesCube`
   - Click **OK**

   ⚠️ Deployment server is **SSAS instance name**, not an ADO.NET provider string.

2. **Build the Solution**:
   - Right-click project → **Build**
   - Check **Output** window for success message

3. **Deploy the Cube**:
   - Right-click project → **Deploy**
   - This builds AND deploys to SSAS server
   - **Output** window shows progress
   - Wait for "Deploy Succeeded" message

4. **Process the Cube**:
   - After deployment, a dialog may ask to process
   - Click **Yes** to process now
   - Or: In **Cube Designer** → **Browser** tab → **Reconnect**
   - Click **Process** button in toolbar
   - In Process dialog, click **Run**
   - Wait for processing to complete (may take a few minutes with 2.5M rows)
   - Click **Close** when done

✅ **Result**: Cube deployed and processed with data

---

## STEP 8: Browse and Test Cube

### Verify Cube Works:

1. **In Cube Designer, click "Browser" tab**

2. **Drag and drop to test**:
   - From **Metadata** pane (left), expand:
     - **Date** dimension → **Date Hierarchy**
     - **Measures** → **Fact Sales**

3. **Create simple analysis**:
   - Drag **Date Hierarchy** → **Year** to **Rows**
   - Drag **Sale Amount** to **Data area**
   - You should see sales by year!

4. **Test drill-down**:
   - Double-click a year to drill into quarters
   - Double-click quarter to see months
   - This proves your hierarchy works! ⭐

5. **Try other combinations**:
   - Drag **Vehicle** → **Car Make** to Columns
   - Drag **Customer** → **Region** to Filters
   - Experiment with the data

---

## ✅ SUCCESS CRITERIA

You've successfully created the cube if:
- ✅ Cube deploys without errors
- ✅ Cube processes and loads data
- ✅ Browser shows sales data
- ✅ Date Hierarchy allows drill-down (Year → Quarter → Month → Date)
- ✅ All measures display correctly

---

## 📸 SCREENSHOTS TO CAPTURE FOR ASSIGNMENT

1. Data Source configuration
2. Data Source View with all 4 tables
3. Date dimension with Date Hierarchy
4. Vehicle dimension attributes
5. Customer dimension
6. Cube structure in designer
7. Dimension Usage tab (shows relationships)
8. Measures configuration
9. Deployment success message
10. Browser tab showing sales by year
11. Drill-down demonstration (Year → Quarter)

---

## NEXT STEP

Once cube is working:
- Move to Excel to create OLAP pivot tables
- Demonstrate all 5 OLAP operations
- Then create PowerBI reports

**Current Progress**: Step 2 of 4 (SSAS Cube - 20 marks)

---

*Follow these instructions step-by-step and you'll have a working cube!*
