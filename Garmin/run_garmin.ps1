# -------------------------------
# run_garmin.ps1
# -------------------------------

# Paths
$projectRoot = "C:\Users\Clair\Documents\GitHub\Stress\Garmin"
$binDir      = "$projectRoot\bin"
$prgFile     = "$binDir\StressApp.prg"
$jungleFile  = "$projectRoot\project.jungle"
$developerKey= "C:\Users\Clair\Desktop\Sandbox\garmin_developer_key"
$connectIqSdk= "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0"

$monkeyc  = "$connectIqSdk\bin\monkeyc.bat"
$monkeydo = "$connectIqSdk\bin\monkeydo.bat"
$simulator= "$connectIqSdk\bin\simulator.exe"

# -------------------------------
# Check for running simulator
# -------------------------------
Write-Host "`n[INFO] Checking for running simulator instances..."
$simProc = Get-Process -Name "ConnectIQ" -ErrorAction SilentlyContinue
if ($simProc) {
    Write-Host "[INFO] Simulator running, stopping..."
    $simProc | Stop-Process -Force
}

# -------------------------------
# Ensure bin directory exists
# -------------------------------
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null
}

# -------------------------------
# Compile app
# -------------------------------
Write-Host "`n[BUILD] Compiling Stress app..."
& $monkeyc -f $jungleFile -y $developerKey -o $binDir

if (-not (Test-Path $prgFile)) {
    Write-Error "[ERROR] Build failed: PRG file not found at $prgFile"
    exit 1
}

Write-Host "[BUILD] Build successful: $prgFile"

# -------------------------------
# Launch simulator
# -------------------------------
Write-Host "`n[INFO] Launching simulator..."
& $monkeydo -i $prgFile

Write-Host "`n[INFO] Done."
