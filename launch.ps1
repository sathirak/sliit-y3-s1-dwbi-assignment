# Launch SSMS and Visual Studio for DWBI Assignment
# Run this script from the project folder

Write-Host "=== DWBI Assignment Launcher ===" -ForegroundColor Cyan
Write-Host ""

# Check SQL Server status
$sqlService = Get-Service -Name "MSSQLSERVER" -ErrorAction SilentlyContinue
if ($sqlService) {
    if ($sqlService.Status -eq "Running") {
        Write-Host "✅ SQL Server is running" -ForegroundColor Green
    } else {
        Write-Host "⚠️  SQL Server is stopped. Starting..." -ForegroundColor Yellow
        Start-Service MSSQLSERVER -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3
        Write-Host "✅ SQL Server started" -ForegroundColor Green
    }
} else {
    Write-Host "❌ SQL Server service not found!" -ForegroundColor Red
}

Write-Host ""

# Launch Visual Studio with ETL project
$vsPath = "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\devenv.exe"
$projectPath = "$PSScriptRoot\etl\CarSalesETL.slnx"

if (Test-Path $vsPath) {
    Write-Host "🚀 Launching Visual Studio with ETL project..." -ForegroundColor Cyan
    Start-Process $vsPath -ArgumentList "`"$projectPath`""
    Write-Host "✅ Visual Studio launched" -ForegroundColor Green
} else {
    Write-Host "❌ Visual Studio not found at: $vsPath" -ForegroundColor Red
}

Write-Host ""

# Try to launch SSMS
$ssmsLocations = @(
    "C:\Program Files (x86)\Microsoft SQL Server Management Studio 20\Common7\IDE\Ssms.exe",
    "C:\Program Files (x86)\Microsoft SQL Server Management Studio 19\Common7\IDE\Ssms.exe",
    "C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe"
)

$ssmsFound = $false
foreach ($loc in $ssmsLocations) {
    if (Test-Path $loc) {
        Write-Host "🚀 Launching SQL Server Management Studio..." -ForegroundColor Cyan
        Start-Process $loc
        Write-Host "✅ SSMS launched" -ForegroundColor Green
        $ssmsFound = $true
        break
    }
}

if (-not $ssmsFound) {
    Write-Host "⚠️  SSMS not found. Install options:" -ForegroundColor Yellow
    Write-Host "   1. Run: C:\Users\Admin\Downloads\vs_SSMS.exe" -ForegroundColor White
    Write-Host "   2. Or: C:\Users\Admin\Downloads\SQL2025-SSEI-StdDev.exe" -ForegroundColor White
    Write-Host ""
    
    $response = Read-Host "Would you like to install SSMS now? (y/n)"
    if ($response -eq 'y') {
        $installer = "C:\Users\Admin\Downloads\vs_SSMS.exe"
        if (Test-Path $installer) {
            Write-Host "🚀 Starting SSMS installer..." -ForegroundColor Cyan
            Start-Process $installer
        } else {
            Write-Host "❌ Installer not found at: $installer" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "📚 Next Steps:" -ForegroundColor Cyan
Write-Host "   1. In SSMS: Connect to 'localhost' with Windows Authentication" -ForegroundColor White
Write-Host "   2. In SSMS: Open and run sql\task4_dw_schema.sql" -ForegroundColor White
Write-Host "   3. In SSMS: Open and run sql\task5_etl_sql_support.sql" -ForegroundColor White
Write-Host "   4. In Visual Studio: Configure connection managers in SSIS packages" -ForegroundColor White
Write-Host "   5. In Visual Studio: Update file paths to point to data\ folder" -ForegroundColor White
Write-Host ""
Write-Host "📖 See docs\VERIFICATION_GUIDE.md for detailed instructions" -ForegroundColor Yellow
Write-Host ""
