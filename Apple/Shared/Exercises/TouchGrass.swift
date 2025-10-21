//
//  TouchGrass.swift
//  Stress
//
//  Created by Claire Kraft on 10/15/25.
//  Physical / outdoor grounding exercise
//

import SwiftUI
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Manager
final class TouchGrassManager: ObservableObject {
    @Published var remainingSeconds: Int = 60
    @Published var progress: Double = 0.0
    @Published var isRunning: Bool = false
    @Published var instruction: String = "Sit on the ground or a flat surface, lower your center of gravity, pace slowly, and count your steps."

    private var timer: Timer?
    private var startTime: Date?

    var duration: Int = 60 // default 1 minute, can be increased
    var onComplete: (() -> Void)?

    func start() {
        guard !isRunning else { return }
        isRunning = true
        startTime = Date()
        remainingSeconds = duration
        progress = 0.0
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
        remainingSeconds = duration
        progress = 0.0
    }

    private func tick() {
        guard let start = startTime else { return }
        let elapsed = Int(Date().timeIntervalSince(start))
        let remaining = max(0, duration - elapsed)
        remainingSeconds = remaining
        progress = Double(elapsed) / Double(duration)

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
struct TouchGrassView: View {
    @StateObject var manager = TouchGrassManager(duration: 60) // default 1 min

    var body: some View {
        VStack(spacing: 20) {
            Text("Touch Grass Exercise")
                .font(.title.bold())
                .padding(.top)

            VStack(spacing: 12) {
                Text(manager.instruction)
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
struct TouchGrassView_Previews: PreviewProvider {
    static var previews: some View {
        TouchGrassView()
    }
}
#endif
