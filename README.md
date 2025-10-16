
# Stress Architecture

StressApp (iOS target)
│
├─ StressApp WatchKit App (watchOS target)
│   ├─ InterfaceController.swift        # Watch UI entry point
│   ├─ SwiftUI Views                    # Watch-specific views
│   └─ Watch App Scenes                 # Watch scenes and navigation
│
Shared/
├─ Models/
│   ├─ HRVSample.swift
│   └─ StressDetector.swift
│
├─ Exercises/
│   ├─ FiveFourThreeTwoOne.swift      # 5-4-3-2-1 grounding technique
│   ├─ OneByThirty.swift              # Focus on 1 stimulus for 30s
│   ├─ FourByFour.swift               # Box breathing 4x4
│   ├─ Categorize.swift               # Cognitive grounding prompts
│   └─ TouchGrass.swift               # Physical grounding prompts
│
├─ Views/
│   ├─ StressDashboardView.swift      # Shared stress dashboard
│   └─ SharedComponents/             # Optional: reusable UI elements
│       ├─ ProgressCircleView.swift
│       ├─ CountdownView.swift
│       └─ SquareBreathingView.swift
