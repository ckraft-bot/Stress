# ===============================
# Garmin Stress App Build Script
# ===============================

# --- Project paths ---
$projectRoot = "C:\Users\Clair\Documents\GitHub\Stress\Garmin"
$binDir = "$projectRoot\bin"
$prgFile = "$binDir\stress.prg"
$jungleFile = "$projectRoot\project.jungle"
$developerKey = "C:\Users\Clair\Desktop\Sandbox\garmin_developer_key"

# --- SDK paths ---
$connectIqSdk = "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0"
$monkeyc = "$connectIqSdk\bin\monkeyc.bat"
$monkeydo = "$connectIqSdk\bin\monkeydo.bat"
$simulator = "$connectIqSdk\bin\simulator.exe"

# --- Kill any running simulator processes ---
Write-Host "Checking for running simulator instances..."
$simProc = Get-Process -Name "ConnectIQ" -ErrorAction SilentlyContinue
if ($simProc) {
    foreach ($p in $simProc) {
        Write-Host "Killing simulator PID $($p.Id)..."
        Stop-Process -Id $p.Id -Force
    }
    Start-Sleep -Seconds 2
}

# --- Ensure bin folder exists ---
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null
}

# --- Build the app ---
Write-Host "Building Stress app..."
& $monkeyc -f $jungleFile -y $developerKey -o $prgFile

if (-not (Test-Path $prgFile)) {
    Write-Error "Build failed: PRG file not found at $prgFile"
    exit 1
}

# --- Launch the simulator ---
Write-Host "Launching simulator..."
Start-Process $simulator
Start-Sleep -Seconds 8 # wait for simulator to fully start

# --- Run the app on the simulator ---
Write-Host "Running Stress app on FR265 simulator..."
& $monkeydo $prgFile fr265

Write-Host "Done! Stress app should now be running on the simulator."
