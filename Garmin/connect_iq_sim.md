# Build and run the app in the CIQ simulator
1. Open PowerShell in the Garmin folder.
2. Run the project script:
```
.\run_garmin.ps1
```

What the script does:
1. Stops any running Connect IQ simulator instance.
2. Ensures the bin folder exists.
3. Builds with monkeyc, the developer key, and the explicit `fr265` target to `bin/stress.prg`.
4. Launches `simulator.exe` asynchronously so the script can continue.
5. Installs and runs the app on `fr265` via `monkeydo`.

The simulator may print diagnostic output such as `[GFX]: Peak Active Workareas: 1`.
This is normal graphics usage information, not an error.

Manual commands (if needed):
```
mkdir bin -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path bin

& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeyc.bat" -f "C:\Users\Clair\Documents\GitHub\Stress\Garmin\project.jungle" -d fr265 -y "C:\Users\Clair\Desktop\Sandbox\garmin_developer_key" -o "C:\Users\Clair\Documents\GitHub\Stress\Garmin\bin\stress.prg"

Start-Process "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\simulator.exe"
Start-Sleep -Seconds 2

& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeydo.bat" "C:\Users\Clair\Documents\GitHub\Stress\Garmin\bin\stress.prg" fr265

taskkill /IM ConnectIQ.exe /F
```

# Install on a Forerunner 265

1. Build the app for the device so it generates a `.prg` file.
2. Connect the FR265 to your PC.
3. If Garmin Express opens automatically, close it.
4. In VS Code, run `Monkey C: Verify Installation`, then `Monkey C: Build for Device` and select `Forerunner 265`.
5. Copy the newly generated `.prg` file into `GARMIN\APPS`. Remove any older copy of the app first.
6. Safely eject the watch from the PC.
7. Open the app on the watch.

If the watch reports `Signature check failed`, delete the old app file and repeat
the build with `Monkey C: Build for Device`, selecting `Forerunner 265`. Do not
copy the simulator output. The generated PRG must be copied unchanged from the
device-build output folder to `GARMIN\APPS`, and the developer key used by the
build must be the key configured for this project.
