# Build and run the app in the CIQ simulator
1. Open PowerShell in the Garmin folder.
2. Run the project script:
```
.\run_garmin.ps1
```

What the script does:
1. Stops any running Connect IQ simulator instance.
2. Ensures the bin folder exists.
3. Builds with monkeyc and developer key to bin/stress.prg.
4. Launches simulator.exe.
5. Installs and runs the app on fr265 via monkeydo.

Manual commands (if needed):
```
mkdir bin -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path bin

& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeyc.bat" -f "C:\Users\Clair\Documents\GitHub\Stress\Garmin\project.jungle" -y "C:\Users\Clair\Desktop\Sandbox\garmin_developer_key" -o "C:\Users\Clair\Documents\GitHub\Stress\Garmin\bin\stress.prg"

Start-Process "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\simulator.exe"

& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeydo.bat" "C:\Users\Clair\Documents\GitHub\Stress\Garmin\bin\stress.prg" fr265

taskkill /IM ConnectIQ.exe /F
```

# Get into Garmin watch FR265

1. Build the app for the device so it generates a `.prg` file.
2. Connect the FR265 to your PC.
3. If Garmin Express opens automatically, close it.
4. In the vs code type `ctrl + shift + p` > `Monkey C: Verify Installation` > `ctrl + shift + p` > `Monkey C: Build for Device` > `Forerunner 265
5. Copy the generated `.prg` file into `GARMIN\APPS`.
6. Safely eject the watch from the PC.
7. Open the app on the watch.
