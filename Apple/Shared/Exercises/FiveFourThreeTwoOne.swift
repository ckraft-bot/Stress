//
//  FiveFourThreeTwoOne.swift
//  Stress
//
//  Created by Claire Kraft on 10/15/25.
//  5-4-3-2-1 Grounding technique (5 steps, 1 minute each)
//

import SwiftUI
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

final class FiveFourThreeTwoOneManager: ObservableObject {
    struct Step: Identifiable {
        let id = UUID()
        let title: String
        let instruction: String
    }

    let steps: [Step] = [
        Step(title: "See 5 things", instruction: "Look around and name 5 things you can see."),
        Step(title: "Touch 4 things", instruction: "Notice 4 things you can touch and how they feel."),
        Step(title: "Hear 3 things", instruction: "Listen for 3 distinct sounds."),
        Step(title: "Smell 2 things", instruction: "Find or notice 2 smells around you."),
        Step(title: "Taste 1 thing", instruction: "Notice one thing you can taste (or imagine a taste).")
    ]

    @Published var currentStepIndex: Int? = nil
    @Published var remainingSeconds: Int = 0
    @Published var stepProgress: Double = 0.0
    @Published var overallProgress: Double = 0.0
    @Published var isRunning: Bool = false

    private var stepTimer: Timer?
    private var perSecondTimer: Timer?
    private var stepStartTime: Date?
    private let stepDurationSeconds: Int

    var onComplete: (() -> Void)?

    init(stepDurationSeconds: Int = 60) { // 1 min per step
        self.stepDurationSeconds = stepDurationSeconds
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        startStep(at: 0)
    }

    func stop() {
        invalidateTimers()
        resetState()
    }

    private func resetState() {
        currentStepIndex = nil
        remainingSeconds = 0
        stepProgress = 0
        overallProgress = 0
        isRunning = false
    }

    private func startStep(at index: Int) {
        guard index < steps.count else {
            completeAll()
            return
        }
        currentStepIndex = index
        stepProgress = 0
        remainingSeconds = stepDurationSeconds
        stepStartTime = Date()

        playCue()
        triggerHaptic()

        perSecondTimer?.invalidate()
        perSecondTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tickSecond()
        }

        stepTimer?.invalidate()
        stepTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(stepDurationSeconds), repeats: false) { [weak self] _ in
            self?.advanceStep()
        }

        updateOverallProgress()
    }

    private func tickSecond() {
        guard let start = stepStartTime else { return }
        let elapsed = Int(Date().timeIntervalSince(start))
        remainingSeconds = max(stepDurationSeconds - elapsed, 0)
        stepProgress = min(1.0, Double(elapsed) / Double(stepDurationSeconds))
        updateOverallProgress()
    }

    private func advanceStep() {
        perSecondTimer?.invalidate()
        stepTimer?.invalidate()
        playCue()
        triggerHaptic()
        if let idx = currentStepIndex, idx + 1 < steps.count {
            startStep(at: idx + 1)
        } else {
            completeAll()
        }
    }

    private func completeAll() {
        invalidateTimers()
        isRunning = false
        currentStepIndex = nil
        remainingSeconds = 0
        stepProgress = 1
        overallProgress = 1
        onComplete?()
        playCompletionCue()
        triggerHaptic(style: .success)
    }

    private func invalidateTimers() {
        perSecondTimer?.invalidate()
        perSecondTimer = nil
        stepTimer?.invalidate()
        stepTimer = nil
    }

    private func updateOverallProgress() {
        guard let idx = currentStepIndex else {
            overallProgress = isRunning ? 0 : 1
            return
        }
        overallProgress = (Double(idx) + stepProgress) / Double(steps.count)
    }

    private func playCue() {
        AudioServicesPlaySystemSound(SystemSoundID(1104))
    }

    private func playCompletionCue() {
        AudioServicesPlaySystemSound(SystemSoundID(1001))
    }

    private func triggerHaptic(style: UINotificationFeedbackGenerator.FeedbackType = .warning) {
        #if canImport(UIKit)
        let gen = UINotificationFeedbackGenerator()
        gen.prepare()
        gen.notificationOccurred(style)
        #endif
    }
}

struct FiveFourThreeTwoOneView: View {
    @StateObject var manager = FiveFourThreeTwoOneManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("5-4-3-2-1 Grounding")
                .font(.title.bold())
                .padding(.top)

            if let idx = manager.currentStepIndex {
                let step = manager.steps[idx]
                VStack(spacing: 8) {
                    Text(step.title).font(.headline)
                    Text(step.instruction)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Text(formatTime(manager.remainingSeconds))
                        .font(.largeTitle.monospacedDigit())
                        .bold()
                        .padding(.top)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
            } else {
                VStack(spacing: 8) {
                    Text("Ready to Ground").font(.headline)
                    Text("Use this 5-4-3-2-1 technique to reduce stress. Each step lasts 1 minute.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }

            ProgressView(value: manager.stepProgress)
                .progressViewStyle(.linear)
                .frame(height: 10)
                .padding(.horizontal, 40)

            ProgressView(value: manager.overallProgress)
                .progressViewStyle(.linear)
                .frame(height: 8)
                .padding(.horizontal, 40)
            Text("\(Int(manager.overallProgress*100))% complete")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            HStack(spacing: 16) {
                if manager.isRunning {
                    Button("Stop") { manager.stop() }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                } else {
                    Button("Start Grounding") { manager.start() }
                        .buttonStyle(.borderedProminent)
                }
                Button("Reset") { manager.stop() }
                    .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .onDisappear { manager.stop() }
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

#if DEBUG
struct FiveFourThreeTwoOneView_Previews: PreviewProvider {
    static var previews: some View {
        FiveFourThreeTwoOneView()
    }
}
#endif
