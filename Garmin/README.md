## Garmin Stress Assistant

### App Summary
Garmin Stress Assistant is a privacy-first wearable app that estimates elevated stress states from physiological patterns and guides the user through short regulation exercises.

The app does not diagnose stress or medical conditions. It identifies sustained deviations from a personal baseline and offers wellness support at the right time.

### Architecture
The watch app is organized as a modular pipeline:

1. Data Input Layer
- Receives heart rate and RR interval data.
- Uses a simulator-safe fallback stream when live sensor APIs are unavailable.

2. Baseline Engine
- Continuously learns the user baseline from resting windows.
- Tracks baseline heart rate and baseline HRV trend.

3. Context Detector
- Labels current state as resting, exercise-like, or post-activity recovery.
- Suppresses stress estimation during exercise and recovery windows.

4. Stress Estimator
- Produces a stress probability score from HR/HRV deviations.
- Adds confidence and factor explanations for transparency.

5. Regulation Engine
- Requires sustained elevation before prompting intervention.
- Applies cooldown logic to avoid repeated alerts.
- Runs guided protocols and captures simple feedback.

6. UI and Interaction
- Displays stress percentage, context state, confidence, and top contributing factor.
- Supports on-watch controls for regulation flow:
    - Select: choose or confirm
    - Down: alternate choice / negative feedback
    - Up: skip prompt

### Feature Highlights
- Personalized baseline adaptation
- Context-aware suppression to reduce false positives
- Sustained trigger window before prompting
- Guided breathing exercises:
    - Resonant breathing (5s inhale / 5s exhale)
    - Box breathing (4-4-4-4)
- Post-intervention feedback capture (Yes/No)
- Cooldown and recovery-aware prompting behavior
- Explainable output (probability, confidence, factor)

### Privacy and Safety
- On-device estimation focused on derived metrics.
- No medical claims or diagnoses.
- Designed as a supportive self-regulation tool for wellness.



