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

# For testing (in the terminal)
1. cd to project root `cd C:\Users\<path>\Garmin`
2. ctrl + shift + p
   - Monkey C: Verify Installation
   - Monkey C: Build Current Project
   - Developer: Reload Window