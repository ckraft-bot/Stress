
# Stress Architecture

StressApp (iOS target)
│
├─ StressApp WatchKit App (watchOS target)
│   ├─ InterfaceController.swift       # watchOS entry point
│   ├─ WatchMenuView.swift             # watch menu UI
│   └─ Watch App Scenes
│
├─ Shared/                             # Shared between iOS & watchOS
│   ├─ Models/
│   │    ├─ HRVSample.swift            # Heart rate & HRV model
│   │    └─ StressDetector.swift       # Stress detection & grounding initiation
│   │
│   ├─ Exercises/
│   │    ├─ FiveFourThreeTwoOne.swift  # 5-4-3-2-1 grounding technique
│   │    ├─ OneByThirty.swift          # Focus on 1 stimulus for 30s
│   │    ├─ FourByFour.swift           # Box breathing 4x4
│   │    ├─ Categorize.swift           # Cognitive grounding
│   │    ├─ TouchGrass.swift           # Physical grounding
│   │    └─ ExerciseData.swift         # Optional: prompt data shared by exercises
│   │
│   └─ Views/
│        ├─ StressView.swift           # Shared dashboard for HR & stress visualization
│        ├─ ExercisesMenuView.swift    # Scrollable list of exercises
│        └─ Components/
│             ├─ Countdown.swift      # Reusable countdown view
│             ├─ ProgressCircle.swift # Reusable circular progress view
│             └─ Square.swift         # Reusable square for box breathing visual

Garmin/
│
├── manifest.xml
├── project.jungle
├── run_garmin.ps1
├── README.md
│
├── bin/
│
├── source/
│   └── StressApp.mc
│
└── resource/
    ├── drawables.xml
    ├── images/
    │   └── launcher_icon.png
    └── strings/
        └── strings.xml



# Flow
How the StressDetector triggers grounding exerices and how the UI components connect on iOS vs WatchOS

[HR/HRV Sensor Input] 
       │
       ▼
[StressDetector (Shared/Models)]
       │
       │ Detects stress → triggers grounding/exercise
       ▼
[Shared Views]
 ┌───────────────────────────────┐
 │ StressView.swift              │  <-- Shows live HR, HRV, stress state
 │ ExercisesMenuView.swift       │  <-- List of exercises
 │ └─ Components/                │
 │      ├─ Countdown.swift       │
 │      ├─ ProgressCircle.swift  │
 │      └─ Square.swift          │
 └───────────────────────────────┘
       │
       │ Presents selected exercise
       ▼
[Shared Exercises] 
 ┌─────────────────────────────────────────┐
 │ FiveFourThreeTwoOne.swift               │
 │ OneByThirty.swift                       │
 │ FourByFour.swift                        │
 │ Categorize.swift                        │
 │ TouchGrass.swift                        │
 └─────────────────────────────────────────┘
       │
       ▼
[UI Output]
 ┌─────────────┐       ┌───────────────┐
 │ iOS App     │       │ watchOS App   │
 │ WindowGroup │       │ InterfaceController/Views
 │ + Sheets    │       │ + Scrollable menu
 └─────────────┘       └───────────────┘
