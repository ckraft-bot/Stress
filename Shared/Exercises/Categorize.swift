//
//  Categorize.swift
//  Stress
//
//  Created by Claire Kraft on 10/15/25.
//  Cognitive grounding prompts (3 minutes)
//

import SwiftUI
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Model
struct Prompt: Identifiable {
    let id = UUID()
    let title: String
    let instruction: String
}

// MARK: - Manager
final class CategorizeManager: ObservableObject {
    @Published var currentPrompt: Prompt?
    @Published var remainingSeconds: Int = 180
    @Published var progress: Double = 0.0
    @Published var isRunning: Bool = false

    private var timer: Timer?
    private var startTime: Date?

    let prompts: [Prompt] = [
        Prompt(title: "Date & Time & Location", instruction: "List the current date, time, and your location."),
        Prompt(title: "Periodic Table Elements", instruction: "Name as many chemical elements as you can."),
        Prompt(title: "Planets, Moons & Stars", instruction: "List planets, moons, and stars."),
        Prompt(title: "Prime Numbers", instruction: "List prime numbers in order."),
        Prompt(title: "Countries", instruction: "List countries you know."),
        Prompt(title: "Movie Characters", instruction: "Name movie characters you can think of."),
        Prompt(title: "Programming Languages", instruction: "List programming languages."),
        Prompt(title: "Metro Stations", instruction: "Name metro/train stations you know.")
    ]

    var onComplete: (() -> Void)?

    func start() {
        guard !isRunning else { return }
        isRunning = true
        startTime = Date()
        remainingSeconds = 180
        progress = 0.0
        // Select a single random prompt for the entire session
        currentPrompt = prompts.randomElement()
        triggerHaptic()
        playCue()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        remainingSeconds = 180
        progress = 0.0
        currentPrompt = nil
    }

    private func tick() {
        guard let start = startTime else { return }
        let elapsed = Int(Date().timeIntervalSince(start))
        let remaining = max(0, 180 - elapsed)
        remainingSeconds = remaining
        progress = Double(elapsed) / 180.0

        if remaining <= 0 {
            complete()
        }
    }

    private func complete() {
        stop()
        playCompletionCue()
        triggerHaptic(style: .success)
        onComplete?()
    }

    // MARK: - Sound & Haptic
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

// MARK: - View
struct CategorizeView: View {
    @StateObject var manager = CategorizeManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Cognitive Grounding")
                .font(.title.bold())
                .padding(.top)

            if let prompt = manager.currentPrompt {
                VStack(spacing: 12) {
                    Text(prompt.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text(prompt.instruction)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Text(timeString(from: manager.remainingSeconds))
                        .font(.largeTitle.monospacedDigit())
                        .bold()
                        .padding(.top, 8)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
            } else {
                Text("Ready to start cognitive grounding for 3 minutes")
                    .multilineTextAlignment(.center)
                    .padding()
            }

            ProgressView(value: manager.progress)
                .progressViewStyle(.linear)
                .frame(height: 10)
                .padding(.horizontal, 40)

            Spacer()

            HStack(spacing: 16) {
                if manager.isRunning {
                    Button("Stop") { manager.stop() }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                } else {
                    Button("Start") { manager.start() }
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

    private func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

#if DEBUG
struct CategorizeView_Previews: PreviewProvider {
    static var previews: some View {
        CategorizeView()
    }
}
#endif
