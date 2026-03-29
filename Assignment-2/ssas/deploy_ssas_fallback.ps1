# Fallback SSAS deployment script for SQL Server 2025 edition/client mismatches.
# Uses Microsoft.AnalysisServices.Deployment.exe from SSMS (newer client library).
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\deploy_ssas_fallback.ps1 -Server "localhost" -ProjectBinPath ".\CarSalesCube\CarSalesCube\bin"

param(
    [string]$Server = "localhost",
    [string]$ProjectBinPath = ".\CarSalesCube\CarSalesCube\bin",
    [switch]$GenerateScriptOnly,
    [switch]$SanitizeDateDimension = $true
)

$ErrorActionPreference = "Stop"

function Write-Step($text) {
    Write-Host "==> $text" -ForegroundColor Cyan
}

function Get-DeploymentExe {
    $candidates = @(
        "C:\Program Files\Microsoft SQL Server Management Studio 22\Release\Common7\IDE\Microsoft.AnalysisServices.Deployment.exe",
        "C:\Program Files\Microsoft SQL Server Management Studio 21\Common7\IDE\Microsoft.AnalysisServices.Deployment.exe",
        "C:\Program Files\Microsoft SQL Server Management Studio 20\Common7\IDE\Microsoft.AnalysisServices.Deployment.exe"
    )

    foreach ($path in $candidates) {
        if (Test-Path $path) { return $path }
    }

    throw "Microsoft.AnalysisServices.Deployment.exe not found. Install SSMS 22+."
}

Write-Step "Resolving project artifacts"
$fullBin = Resolve-Path $ProjectBinPath
$asdbPath = Join-Path $fullBin "CarSalesCube.asdatabase"
$targetsPath = Join-Path $fullBin "CarSalesCube.deploymenttargets"
$optionsPath = Join-Path $fullBin "CarSalesCube.deploymentoptions"

if (!(Test-Path $asdbPath)) {
    throw "Missing file: $asdbPath. Build the SSAS project first in Visual Studio."
}
if (!(Test-Path $targetsPath)) {
    throw "Missing file: $targetsPath. Build the SSAS project first in Visual Studio."
}
if (!(Test-Path $optionsPath)) {
    throw "Missing file: $optionsPath. Build the SSAS project first in Visual Studio."
}

[xml]$targetsXml = Get-Content $targetsPath -Raw
$dbName = $targetsXml.DeploymentTarget.Database
if ([string]::IsNullOrWhiteSpace($dbName)) { $dbName = "CarSalesCube" }

Write-Step "Updating deployment target server"
$targetsXml.DeploymentTarget.Server = $Server
$targetsXml.DeploymentTarget.ConnectionString = "Data Source=$Server;Timeout=0"
$targetsXml.Save($targetsPath)

Write-Step "Locating deployment utility"
$deployExe = Get-DeploymentExe
Write-Host "Using: $deployExe" -ForegroundColor Green

if ($SanitizeDateDimension) {
    Write-Step "Sanitizing Date dimension in .asdatabase (compatibility hardening)"
    $raw = Get-Content $asdbPath -Raw

    # Remove Date Key -> Full Date attribute relationship if present
    $raw = $raw -replace '(?s)<AttributeRelationship>\s*<AttributeID>Full Date</AttributeID>\s*<Name>Full Date</Name>\s*</AttributeRelationship>', ''

    # Ensure Date Key is simple single-column key by removing any secondary full_date key column under Date Key
    $raw = $raw -replace '(?s)(<Attribute>\s*<ID>Date Key</ID>.*?<KeyColumns>)(.*?)(<KeyColumn>\s*<DataType>Date</DataType>\s*<Source xsi:type="ColumnBinding">\s*<TableID>dbo_dim_date</TableID>\s*<ColumnID>full_date</ColumnID>\s*</Source>\s*</KeyColumn>)(.*?</KeyColumns>.*?</Attribute>)', '$1$2$4'

    # Remove standalone Full Date attribute block if present
    $raw = $raw -replace '(?s)<Attribute>\s*<ID>Full Date</ID>.*?</Attribute>', ''

    # Keep NameColumn stable for Date Key
    $raw = $raw -replace '(?s)<NameColumn>\s*<DataType>WChar</DataType>\s*<Source xsi:type="ColumnBinding">\s*<TableID>dbo_dim_date</TableID>\s*<ColumnID>full_date</ColumnID>\s*</Source>\s*</NameColumn>', '<NameColumn><DataType>WChar</DataType><DataSize>30</DataSize><Source xsi:type="ColumnBinding"><TableID>dbo_dim_date</TableID><ColumnID>full_date</ColumnID></Source></NameColumn>'

    Set-Content -Path $asdbPath -Value $raw -Encoding UTF8
}

if ($GenerateScriptOnly) {
    Write-Step "Generating deployment XMLA script only"
    $scriptOut = Join-Path $fullBin "CarSalesCube.generated-deploy.xmla"
    & $deployExe $asdbPath "/o:$scriptOut"
    if ($LASTEXITCODE -ne 0) { throw "Script generation failed." }
    Write-Host "Generated: $scriptOut" -ForegroundColor Green
} else {
    Write-Step "Deploying '$dbName' in silent mode"
    $logPath = Join-Path $fullBin "CarSalesCube.deploy.log"
    & $deployExe $asdbPath "/s:$logPath"
    if ($LASTEXITCODE -ne 0) {
        throw "Deployment failed. Check log: $logPath"
    }
    Write-Host "Deployment succeeded. Log: $logPath" -ForegroundColor Green
}

Write-Step "Done"
