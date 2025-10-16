//
//  main.swift
//  StressApp Windows Test Harness
//

import Foundation
// Make sure your Shared folder is in the same project directory and accessible
// import SharedModels
// import SharedExercises

// Simulate your StressDetector logic
class StressDetectorMock {
    var hrBaseline: Double
    var hrvBaseline: Double
    var samples: [(heartRate: Double, hrv: Double, stressDetected: Bool)] = []

    init(hrBaseline: Double, hrvBaseline: Double) {
        self.hrBaseline = hrBaseline
        self.hrvBaseline = hrvBaseline
    }

    func addSample(heartRate: Double, hrv: Double) {
        var stressDetected = false
        if heartRate > hrBaseline + 10 && hrv < hrvBaseline - 5 {
            stressDetected = true
            print("⚠️ Stress detected! Starting grounding exercise...")
        }
        samples.append((heartRate, hrv, stressDetected))
    }
}

// Simulate 5-4-3-2-1 grounding
func simulateFiveFourThreeTwoOne(stepDuration: Int = 5) {
    let steps = [
        "See 5 things",
        "Touch 4 things",
        "Hear 3 things",
        "Smell 2 things",
        "Taste 1 thing"
    ]

    for step in steps {
        print("\n🧘 Grounding Step: \(step)")
        for second in 1...stepDuration {
            print("Time: \(second)s / \(stepDuration)s", terminator: "\r")
            Thread.sleep(forTimeInterval: 1.0)
        }
        print("✅ Step complete: \(step)")
    }

    print("\n🎉 Grounding complete!")
}

// Simulate OneByThirty (30-second single stimulus)
func simulateOneByThirty() {
    let duration = 30
    print("\n👁 Focus on one stimulus for 30 seconds")
    for second in 1...duration {
        print("Time: \(second)s / \(duration)s", terminator: "\r")
        Thread.sleep(forTimeInterval: 1.0)
    }
    print("\n✅ OneByThirty complete!")
}

// Simulate Categorize (3-minute cognitive prompt)
func simulateCategorize() {
    let prompts = [
        "Date & Time & Location",
        "Periodic Table Elements",
        "Planets, Moons & Stars",
        "Prime Numbers",
        "Countries",
        "Movie Characters",
        "Programming Languages",
        "Metro Stations"
    ]
    
    let selectedPrompt = prompts.randomElement()!
    let duration = 180 // 3 minutes
    
    print("\n🧠 Cognitive Grounding Prompt: \(selectedPrompt)")
    for second in 1...duration {
        let minutes = second / 60
        let seconds = second % 60
        print(String(format: "Time: %02d:%02d / 03:00", minutes, seconds), terminator: "\r")
        Thread.sleep(forTimeInterval: 1.0)
    }
    print("\n✅ Cognitive grounding complete!")
}

// Test harness
let detector = StressDetectorMock(hrBaseline: 70, hrvBaseline: 50)

// Add some sample readings
detector.addSample(heartRate: 72, hrv: 55)
detector.addSample(heartRate: 85, hrv: 45) // should trigger stress

print("\n--- Simulating 5-4-3-2-1 Grounding ---")
simulateFiveFourThreeTwoOne(stepDuration: 5) // shorter for quick test

print("\n--- Simulating OneByThirty ---")
simulateOneByThirty()

print("\n--- Simulating Cognitive Prompt ---")
simulateCategorize()

print("\nAll simulations complete ✅")
