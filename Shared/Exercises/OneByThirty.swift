//
//  OneByThirty.swift
//  Stress
//
//  Created by Claire Kraft on 10/15/25.
//  Focus on one stimulus for 30 seconds
//

import SwiftUI
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

final class OneByThirtyManager: ObservableObject {
    @Published var remainingSeconds: Int = 30
    @Published var progress: Double = 0.0
    @Published var isRunning: Bool = false

    private var timer: Timer?
    private let totalSeconds: Int = 30

    var onComplete: (() -> Void)?

    func start() {
        guard !isRunning else { return }
        isRunning = true
        remainingSeconds = totalSeconds
        progress = 0.0
        playCue()
        triggerHaptic()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        remainingSeconds = totalSeconds
        progress = 0.0
    }

    private func tick() {
        remainingSeconds -= 1
        progress = Double(totalSeconds - remainingSeconds) / Double(totalSeconds)

        if remainingSeconds <= 0 {
            complete()
        }
    }

    private func complete() {
        stop()
        playCompletionCue()
        triggerHaptic(style: .success)
        onComplete?()
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

struct OneByThirtyView: View {
    @StateObject var manager = OneByThirtyManager()
    let stimulus: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Focus on 1 thing")
                .font(.title.bold())
                .padding(.top)

            Text("Stimulus: \(stimulus)")
                .font(.headline)
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            Text(formatTime(manager.remainingSeconds))
                .font(.largeTitle.monospacedDigit())
                .bold()
                .padding()

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

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

#if DEBUG
struct OneByThirtyView_Previews: PreviewProvider {
    static var previews: some View {
        OneByThirtyView(stimulus: "Sight")
    }
}
#endif
