# DWBI Assignment - Verification Guide

## 🔧 Prerequisites Check

### SQL Server Status
✅ SQL Server (MSSQLSERVER) - Running
- The database engine is ready to use

### Installed Software
✅ Visual Studio Community - Found at: `C:\Program Files\Microsoft Visual Studio\18\Community`
⚠️ SSMS - Install from Downloads folder: `vs_SSMS.exe` or `SQL2025-SSEI-StdDev.exe`

---

## 📋 Step-by-Step Verification

### Part 1: Install/Launch SSMS (SQL Server Management Studio)

**Option A: If SSMS is not installed**
1. Navigate to `C:\Users\Admin\Downloads`
2. Run `vs_SSMS.exe` to install SSMS
3. Follow the installation wizard
4. Restart if prompted

**Option B: If SSMS is already installed**
1. Press `Windows Key` and type "SSMS" or "SQL Server Management Studio"
2. Click to launch
3. Or run from PowerShell: `Start-Process ssms`

**Connect to SQL Server:**
```
Server name: localhost
OR: (local)
OR: .
Authentication: Windows Authentication
```

---

### Part 2: Verify Database Setup with SSMS

Once SSMS is open and connected:

**Step 1: Create the Data Warehouse Schema**
1. Click **File → Open → File**
2. Navigate to: `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\sql\task4_dw_schema.sql`
3. Review the SQL script
4. Click **Execute** (F5) or press the green play button
5. Check messages for successful execution

**Step 2: Run ETL Support Scripts**
1. Click **File → Open → File**
2. Navigate to: `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\sql\task5_etl_sql_support.sql`
3. Click **Execute** (F5)
4. Verify successful execution in the Messages pane

**Step 3: Verify Database Objects**
1. In Object Explorer, expand **Databases**
2. Look for your data warehouse database (check what was created by task4_dw_schema.sql)
3. Expand **Tables** to see created tables
4. Expand **Stored Procedures** or **Views** if any were created

---

### Part 3: Launch Visual Studio and Open ETL Project

**Launch Visual Studio:**
```powershell
# From PowerShell:
cd "C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\etl"
Start-Process "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\devenv.exe" "CarSalesETL.slnx"
```

**Or manually:**
1. Press `Windows Key` and type "Visual Studio"
2. Launch Visual Studio 2022
3. Click **Open a project or solution**
4. Navigate to: `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\etl\CarSalesETL.slnx`
5. Click **Open**

---

### Part 4: Verify SSIS Packages in Visual Studio

**Check SSIS Project:**
1. In Solution Explorer (right side), expand **CarSalesETL** project
2. You should see:
   - `Package.dtsx`
   - `PackageAccum.dtsx`
   - `Project.params`

**Configure Connection Managers:**
1. Double-click `Package.dtsx` to open it
2. At the bottom, find **Connection Managers** pane
3. Right-click each connection → **Properties**
4. Update connection strings to point to your SQL Server:
   - Server: `localhost` or `(local)`
   - Database: (your data warehouse database name)

**Update File Paths:**
1. Look for **Flat File Connection Managers** (for CSV files)
2. Update the file paths to point to:
   - `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\data\source_customer_master.csv`
   - `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\data\source_sql_sales.csv`
   - `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\data\fact_completion_updates.csv`

**Test the Package:**
1. Click **Debug → Start Debugging** (F5)
2. Watch the package execute (tasks will turn green if successful, red if errors)
3. Review any errors in the **Output** window
4. Stop debugging when complete

---

## 🎯 Quick Start Commands

```powershell
# Navigate to project
cd "C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment"

# Launch Visual Studio with ETL project
Start-Process "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\devenv.exe" "etl\CarSalesETL.slnx"

# Launch SSMS (if installed)
Start-Process ssms

# Or install SSMS first
Start-Process "C:\Users\Admin\Downloads\vs_SSMS.exe"
```

---

## ✅ Verification Checklist

- [ ] SQL Server is running
- [ ] SSMS is installed and connected to localhost
- [ ] task4_dw_schema.sql executed successfully
- [ ] task5_etl_sql_support.sql executed successfully
- [ ] Database and tables visible in SSMS
- [ ] Visual Studio opened CarSalesETL.slnx
- [ ] SSIS packages visible in Solution Explorer
- [ ] Connection managers configured correctly
- [ ] File paths updated to point to data folder
- [ ] Test package execution runs without errors

---

## 🐛 Troubleshooting

**SQL Server not running:**
```powershell
Start-Service MSSQLSERVER
```

**Cannot connect to SQL Server:**
- Try different server names: `localhost`, `(local)`, `.`, or `127.0.0.1`
- Use Windows Authentication

**SSIS packages won't open:**
- Ensure SQL Server Integration Services is installed with Visual Studio
- Check if you have the "Data Storage and Processing" workload installed

**File path errors in SSIS:**
- Make sure CSV files exist in the `data/` folder
- Use absolute paths: `C:\Users\Admin\Projects\sliit-y3-s1-dwbi-assignment\data\...`
