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

# Build the app for the sim
`cd C:\Users\Clair\Documents\GitHub\Stress\Garmin`

- Create bin folder (one time event)
`mkdir bin -ErrorAction SilentlyContinue`
`New-Item -ItemType Directory -Force -Path bin`

- Build app: use monkeyc.bat instead of jar to build the app
this will compile all my `.mc` files and create `bin\stress.prg`
   - launch the connect IQ sim
   - load the app on the fr265 virtual app
   - start running stress monitoring app
```& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeydo.bat" bin\stress.prg fr265```

# For testing (in the terminal)
1. cd to project root `cd C:\Users\<path>\Garmin`
2. ctrl + shift + p
   - Monkey C: Verify Installation
   - Monkey C: Build Current Project
   - Developer: Reload Window
3. Launch the sim ```Start-Process "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\simulator.exe"```
3. Run the simulator ```& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeydo.bat" bin\stress.prg fr265```
