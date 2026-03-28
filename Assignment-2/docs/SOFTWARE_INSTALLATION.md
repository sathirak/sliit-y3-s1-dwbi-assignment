# Software Installation Guide for DWBI Assignment 2

## Required Software Status

### ✅ Already Installed
- [x] SQL Server 2025 Standard Developer Edition
- [x] Visual Studio 2022 Community
- [x] SQL Server Management Studio (needs installation, installer available)

### ⚠️ Needs Installation
- [ ] SQL Server Data Tools (SSDT) for Analysis Services
- [ ] PowerBI Desktop
- [ ] PowerBI Service Account (online signup)

---

## Installation Instructions

### 1. SQL Server Management Studio (SSMS)

**Status**: Installer available in Downloads

**Steps**:
```powershell
# Run the installer
Start-Process "C:\Users\Admin\Downloads\vs_SSMS.exe"
```

**Or manually**:
1. Navigate to `C:\Users\Admin\Downloads\`
2. Double-click `vs_SSMS.exe`
3. Follow installation wizard
4. Select default options
5. Restart if prompted

**Time**: ~10-15 minutes

---

### 2. SQL Server Data Tools (SSDT) - Analysis Services

**Purpose**: Create and design SSAS Cubes in Visual Studio

**Method 1: Visual Studio Extension (Recommended)**

1. Open Visual Studio 2022
2. Go to **Extensions → Manage Extensions**
3. Search for "Analysis Services"
4. Install **Microsoft Analysis Services Projects 2022**
5. Restart Visual Studio

**Method 2: Standalone Installer**

Download from: https://marketplace.visualstudio.com/items?itemName=ProBITools.MicrosoftAnalysisServicesModelingProjects2022

Or use Visual Studio Installer:
```powershell
# Launch Visual Studio Installer
Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"
```

Then:
1. Click **Modify** on Visual Studio 2022
2. Under **Workloads**, select **Data storage and processing**
3. Under **Individual components**, search and select:
   - SQL Server Data Tools
   - SQL Server Integration Services
   - SQL Server Analysis Services
4. Click **Modify** and wait for installation

**Time**: ~20-30 minutes

---

### 3. PowerBI Desktop

**Purpose**: Create interactive reports and dashboards

**Method 1: Microsoft Store (Easiest - Auto-updates)**

```powershell
# Open Microsoft Store
Start-Process "ms-windows-store://pdp/?ProductId=9NTXR16HNW1T"
```

Then click **Install**

**Method 2: Direct Download**

Download from: https://aka.ms/pbidesktop

Or:
```powershell
# Download PowerBI Desktop installer
$url = "https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe"
$output = "$env:USERPROFILE\Downloads\PBIDesktopSetup.exe"

Invoke-WebRequest -Uri $url -OutFile $output
Start-Process $output
```

**Installation Steps**:
1. Run the downloaded installer
2. Accept license agreement
3. Choose installation location (default is fine)
4. Complete installation
5. Launch PowerBI Desktop

**Time**: ~5-10 minutes

---

### 4. PowerBI Service Account

**Purpose**: Publish reports online for demonstration

**Steps**:

1. Go to: https://app.powerbi.com/

2. Click **Sign up free** or **Try free**

3. Options:
   - **Personal Email**: Use personal Microsoft account
   - **Work/School Email**: Use organizational account
   - **Free Trial**: 60-day Pro trial available

4. For students, you can use:
   - Your university email (@sliit.lk)
   - Or create a free Microsoft account

5. Complete signup process

6. Verify email if required

7. Access PowerBI Service workspace

**Cost**: FREE (with limitations, sufficient for assignment)

**Time**: ~5 minutes

---

### 5. SQL Server Analysis Services (SSAS)

**Purpose**: OLAP Cube engine

**Check if installed**:
```powershell
Get-Service -Name "*Analysis*" -ErrorAction SilentlyContinue
```

**If not installed**:

SSAS should be included with SQL Server 2025 installation. If missing:

1. Run SQL Server Installation Center
   ```powershell
   # Find SQL Server installer
   Start-Process "C:\Users\Admin\Downloads\SQL2025-SSEI-StdDev.exe"
   ```

2. Choose **Installation → New SQL Server stand-alone installation**

3. On Feature Selection, check:
   - **Analysis Services**

4. On Analysis Services Configuration:
   - Choose **Tabular Mode** or **Multidimensional Mode** (use Multidimensional for this assignment)
   - Add current user as administrator

5. Complete installation

**Time**: ~30-45 minutes

---

## Installation Order (Recommended)

**Parallel Installations** (can do simultaneously):
1. PowerBI Desktop (quick, no dependencies)
2. PowerBI Service signup (web-based, no installation)

**Sequential** (do in order):
3. SSMS (if needed)
4. SSDT/Analysis Services Projects extension for VS
5. SSAS Server (if not already installed)

---

## Verification Steps

### Verify SSMS
```powershell
# Launch SSMS
Start-Process "C:\Program Files (x86)\Microsoft SQL Server Management Studio*\Common7\IDE\Ssms.exe"
```

### Verify Visual Studio SSAS Extension
1. Open Visual Studio
2. File → New → Project
3. Search for "Analysis Services"
4. Should see "Analysis Services Multidimensional Project" template

### Verify PowerBI Desktop
```powershell
# Launch PowerBI Desktop
Start-Process "C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
```

### Verify SSAS Service
```powershell
Get-Service -Name "MSSQLServerOLAPService" -ErrorAction SilentlyContinue
```

Should show status: Running

---

## Quick Start Commands

```powershell
# Install PowerBI from Store
Start-Process "ms-windows-store://pdp/?ProductId=9NTXR16HNW1T"

# Open Visual Studio Installer to add SSDT
Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"

# Install SSMS
Start-Process "C:\Users\Admin\Downloads\vs_SSMS.exe"

# Check SSAS service
Get-Service "*Analysis*"

# Launch PowerBI Desktop (after install)
Start-Process "C:\Program Files\Microsoft Power BI Desktop\bin\PBIDesktop.exe"
```

---

## Troubleshooting

**Issue**: Visual Studio can't find Analysis Services template

**Solution**: 
- Make sure you installed the correct extension for VS 2022
- Restart Visual Studio after extension installation
- Check Extensions → Manage Extensions → Installed

**Issue**: SSAS service won't start

**Solution**:
- Check Windows Services (services.msc)
- Find "SQL Server Analysis Services"
- Right-click → Properties → Set to Automatic
- Start the service

**Issue**: PowerBI Desktop won't launch

**Solution**:
- Try reinstalling from Microsoft Store
- Check Windows Updates
- Ensure .NET Framework is up to date

---

## Alternative: Working Without Installations

If you encounter installation issues:

1. **SSAS Cube**: Can be created using SQL Server 2025 built-in tools
2. **PowerBI**: Can use PowerBI Service (web version) for most features
3. **Excel OLAP**: Can connect Excel directly to SQL Server for basic OLAP

However, for full assignment completion, all tools are recommended.

---

*Last Updated*: March 28, 2026
