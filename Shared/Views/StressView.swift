//
//  StressView.swift
//  Stress
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

struct StressView: View {
    @StateObject private var detector = StressDetector(hrBaseline: 70, hrvBaseline: 50)
    @State private var showGrounding = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Stress Detector")
                .font(.largeTitle.bold())
                .padding(.top, 40)
            
            Text(detector.isStressed ? "Stress Detected 😰" : "Calm 😌")
                .font(.title2)
                .foregroundColor(detector.isStressed ? .red : .green)
                .animation(.easeInOut, value: detector.isStressed)

            Spacer()
            
            // Start Grounding button
            Button(action: {
                showGrounding = true
            }) {
                Label("Start Grounding", systemImage: "leaf.fill")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .sheet(isPresented: $showGrounding) {
            FiveFourThreeTwoOneView()
        }
        .onChange(of: detector.isStressed) { newValue in
            if newValue {
                showGrounding = true
            }
        }
    }
}
