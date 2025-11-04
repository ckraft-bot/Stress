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

- Create bin folder
`mkdir bin -ErrorAction SilentlyContinue`
`New-Item -ItemType Directory -Force -Path bin`

- use monkeyc.bat instead of jar to build the app
this will compile all my `.mc` files and create `bin\stress.prg`
```& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeyc.bat" -d fr265 -f monkey.jungle -o bin\stress.prg -y C:\Users\Clair\Desktop\Sandbox\garmin_developer_key```

- launch in sim
```& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\monkeyc.bat" -d fr265 -f monkey.jungle -o bin\stress.prg -y C:\Users\Clair\Desktop\Sandbox\Sandbox\garmin_developer_key```

- Verify you're in the right place
pwd

- Check monkey.jungle exists
Test-Path monkey.jungle

- Check developer key exists  
Test-Path C:\Users\Clair\Desktop\Sandbox\garmin_developer_key

# For testing (in the terminal)
1. cd to project root `cd C:\Users\<path>\Garmin`
2. ctrl + shift + p
   - Monkey C: Verify Installation
   - Monkey C: Build Current Project
   - Developer: Reload Window
3. Run the simulator ```& "C:\Users\Clair\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.3.0-2025-09-22-5813687a0\bin\simulator.exe"```