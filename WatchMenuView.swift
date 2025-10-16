//
//  WatchMenuView.swift
//  Stress Watch
//
//  Created by Claire Kraft on 10/15/25.
//
//  All exercises use shared SwiftUI Views from the Shared/ folder.
//  Watch shows a simple scrollable menu of exercises.
//  Selecting an exercise presents it as a sheet, just like on iOS.
//  Minimal extra logic is required — the heavy lifting is in the shared views.
//  This approach works for watchOS 9+ with SwiftUI.
//

import SwiftUI

struct WatchMenuView: View {
    @State private var selectedExercise: ExerciseType? = nil
    
    // Define the exercises
    enum ExerciseType: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        
        case fiveFourThreeTwoOne = "5-4-3-2-1 Grounding"
        case oneByThirty = "Focus on 1 Stimulus (30s)"
        case fourByFour = "Box Breathing 4x4"
        case categorize = "Categorize Prompt"
        case touchGrass = "Touch Grass / Physical Grounding"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(ExerciseType.allCases) { exercise in
                    Button(action: {
                        selectedExercise = exercise
                    }) {
                        Text(exercise.rawValue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .sheet(item: $selectedExercise) { exercise in
            switch exercise {
            case .fiveFourThreeTwoOne:
                FiveFourThreeTwoOneView()
            case .oneByThirty:
                OneByThirtyView()
            case .fourByFour:
                FourByFourView()
            case .categorize:
                CategorizeView()
            case .touchGrass:
                TouchGrassView()
            }
        }
    }
}

#if DEBUG
struct WatchMenuView_Previews: PreviewProvider {
    static var previews: some View {
        WatchMenuView()
    }
}
#endif
