//
//  ExerciseData.swift
//  Stress
//
//  Created by Claire Kraft on 10/15/25.
//

import SwiftUI

struct ExerciseItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let view: AnyView
}

struct ExerciseData {
    static let allExercises: [ExerciseItem] = [
        ExerciseItem(
            title: "5-4-3-2-1 Grounding",
            description: "Ground yourself using your senses.",
            view: AnyView(FiveFourThreeTwoOneView())
        ),
        ExerciseItem(
            title: "One by Thirty",
            description: "Focus on a single stimulus for 30 seconds.",
            view: AnyView(OneByThirtyView())
        ),
        ExerciseItem(
            title: "Box Breathing 4x4",
            description: "Practice deep breathing with a square visual.",
            view: AnyView(FourByFourView())
        ),
        ExerciseItem(
            title: "Cognitive Grounding",
            description: "Think of one prompt to engage your mind.",
            view: AnyView(CategorizeView())
        ),
        ExerciseItem(
            title: "Touch Grass",
            description: "Lower your center of gravity and pace.",
            view: AnyView(TouchGrassView())
        )
    ]
}
