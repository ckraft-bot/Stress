//
//  WatchMenuView.swift
//  Stress (WatchOS)
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

struct WatchExercisesMenuView: View {
    @State private var selectedExercise: ExerciseItem? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(ExerciseData.allExercises) { exercise in
                    Button(action: { selectedExercise = exercise }) {
                        Text(exercise.title)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue.opacity(0.2)))
                    }
                }
            }
            .padding()
        }
        .sheet(item: $selectedExercise) { item in
            item.view
        }
    }
}
