Project structure

├───Apple
│   │   .gitignore
│   │   README.md
│   │   Stress Research.pdf
│   │   Stressed Sim
│   │   WatchMenuView.swift
│   │   
│   └───Shared
│       ├───Exercises
│       │       Categorize.swift
│       │       ExerciseData.swift
│       │       FiveFourThreeTwoOne.swift
│       │       FourByFour.swift
│       │       OneByThirty.swift
│       │       TouchGrass.swift
│       │
│       ├───Models
│       │       HRVSample.swift
│       │       StressDetector.swift
│       │
│       └───Views
│           │   ExercisesMenuView.swift
│           │   StressView.swift
│           │
│           └───Components
│                   Countdown.swift
│                   ProgressCircle.swift
│                   Square.swift
│
└───Garmin
    │   developer_key
    │   manifest.xml
    │   project.jungle
    │   README.md
    │
    ├───Resources
    │   ├───Images
    │   │       stress-app-icon.png
    │   │
    │   └───Strings
    │           strings.xml
    │
    └───Source
            App.mc
            BreathingView.mc
            FiveFourThreeTwoOne.mc
            MainView.mc
            MenuView.mc

# Build and run the app in the CIQ simulator 
1. cd to project root `cd C:\Users\<path>\Garmin`
2. ctrl + shift + p
   - Monkey C: Verify Installation
   - Monkey C: Build Current Project
   - Developer: Reload Window
3. create `bin` folder 
```
mkdir bin -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path bin
```
4. Build the app (including dev key) 
```
& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeyc.bat" -f "C:\Users\Clair\Documents\GitHub\Stress\Garmin\project.jungle" -y "C:\Users\Clair\Desktop\Sandbox\garmin_developer_key" -o "C:\Users\Clair\Documents\GitHub\Stress\Garmin\bin\stress.prg"
```
5. Launch sim
```
Start-Process "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\simulator.exe"
```
6. Run app
```
& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeydo.bat" bin\stress.prg fr265
```
7. Kill sim
`taskkill /IM ConnectIQ.exe /F`
8. Just run the powershell that handles steps 1-7
`.\run_garmin.ps1`
