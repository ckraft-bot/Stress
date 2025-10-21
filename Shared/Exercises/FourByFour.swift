//
//  FourByFour.swift
//  Stress
//
//  Created by Claire Kraft on 10/15/25.
//  Box breathing 4x4 with square visualization
//

import SwiftUI
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

final class FourByFourManager: ObservableObject {
    @Published var currentSide: Int = 0      // 0..3 for square sides
    @Published var repetition: Int = 1       // 1..3 repetitions
    @Published var progress: Double = 0.0    // 0.0 - 1.0 for current side
    @Published var isRunning: Bool = false

    private var sideTimer: Timer?
    private let sideDuration: TimeInterval = 4
    private let totalRepetitions: Int = 3

    var onComplete: (() -> Void)?

    func start() {
        guard !isRunning else { return }
        isRunning = true
        currentSide = 0
        repetition = 1
        progress = 0.0
        startSide()
        playCue()
        triggerHaptic()
    }

    func stop() {
        sideTimer?.invalidate()
        sideTimer = nil
        isRunning = false
        currentSide = 0
        repetition = 1
        progress = 0.0
    }

    private func startSide() {
        let startTime = Date()
        sideTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let elapsed = Date().timeIntervalSince(startTime)
            self.progress = min(1.0, elapsed / self.sideDuration)
            if elapsed >= self.sideDuration {
                timer.invalidate()
                self.advanceSide()
            }
        }
    }

    private func advanceSide() {
        playCue()
        triggerHaptic()

        if currentSide < 3 {
            currentSide += 1
            progress = 0.0
            startSide()
        } else if repetition < totalRepetitions {
            repetition += 1
            currentSide = 0
            progress = 0.0
            startSide()
        } else {
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

struct FourByFourView: View {
    @StateObject var manager = FourByFourManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Box Breathing 4x4")
                .font(.title.bold())
                .padding(.top)

            SquareBreathingView(currentSide: manager.currentSide,
                                progress: manager.progress)
                .frame(width: 200, height: 200)

            Text("Repetition: \(manager.repetition)/3")
                .font(.headline)

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
}

struct SquareBreathingView: View {
    let currentSide: Int   // 0 = bottom, 1 = right, 2 = top, 3 = left
    let progress: Double   // 0.0 -> 1.0

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                // Draw sides completed in previous steps
                for i in 0..<currentSide {
                    addSide(i, w: w, h: h, path: &path)
                }
                // Draw current side partially
                addPartialSide(currentSide, progress: progress, w: w, h: h, path: &path)
            }
            .stroke(Color.blue, lineWidth: 6)
        }
    }

    private func addSide(_ side: Int, w: CGFloat, h: CGFloat, path: inout Path) {
        switch side {
        case 0: path.move(to: CGPoint(x: 0, y: h)); path.addLine(to: CGPoint(x: w, y: h))
        case 1: path.move(to: CGPoint(x: w, y: h)); path.addLine(to: CGPoint(x: w, y: 0))
        case 2: path.move(to: CGPoint(x: w, y: 0)); path.addLine(to: CGPoint(x: 0, y: 0))
        case 3: path.move(to: CGPoint(x: 0, y: 0)); path.addLine(to: CGPoint(x: 0, y: h))
        default: break
        }
    }

    private func addPartialSide(_ side: Int, progress: Double, w: CGFloat, h: CGFloat, path: inout Path) {
        switch side {
        case 0:
            path.move(to: CGPoint(x: 0, y: h))
            path.addLine(to: CGPoint(x: w * CGFloat(progress), y: h))
        case 1:
            path.move(to: CGPoint(x: w, y: h))
            path.addLine(to: CGPoint(x: w, y: h - h * CGFloat(progress)))
        case 2:
            path.move(to: CGPoint(x: w, y: 0))
            path.addLine(to: CGPoint(x: w - w * CGFloat(progress), y: 0))
        case 3:
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: h * CGFloat(progress)))
        default: break
        }
    }
}

#if DEBUG
struct FourByFourView_Previews: PreviewProvider {
    static var previews: some View {
        FourByFourView()
    }
}
#endif
