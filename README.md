
# Stress Architecture

StressApp (iOS target)
│
├─ StressApp WatchKit App (watchOS target)
│   ├─ InterfaceController.swift        # Watch UI entry point
│   ├─ SwiftUI Views                    # Watch-specific views
│   └─ Watch App Scenes                 # Watch scenes and navigation
│
├─ Shared/
│   ├─ HRVSample.swift                  # Model for heart rate & HRV samples
│   ├─ StressDetector.swift             # Core stress detection logic
│   ├─ FiveFourThreeTwoOne.swift        # 5-4-3-2-1 grounding technique
│   ├─ OneByThirty.swift                # Focus on 1 stimulus for 30 seconds
│   ├─ FourByFour.swift                 # 4x4 / box breathing technique
│   ├─ Categorize.swift                     # Cognitive grounding prompts
│   └─ TouchGrass.swift                 # Physical / outdoor grounding prompts
