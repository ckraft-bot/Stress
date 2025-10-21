//
//  ExercisesMenuView.swift
//  Stress (iOS)
//
//  Created by Claire Kraft on 10/15/25.
//
// Shered exercise list -  works for ios and watchOS
// Scrollable list - shows title and description
// Sheet presentation - opens the exercise using the shared `View`
// Mininmal extra logic - all heavy lifting is in the shared views

struct ExercisesMenuView: View {
    @State private var selectedExercise: ExerciseItem? = nil

    var body: some View {
        NavigationView {
            List(ExerciseData.allExercises) { exercise in
                Button(action: { selectedExercise = exercise }) {
                    VStack(alignment: .leading) {
                        Text(exercise.title).font(.headline)
                        Text(exercise.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Exercises")
            .sheet(item: $selectedExercise) { item in
                item.view
            }
        }
    }
}
