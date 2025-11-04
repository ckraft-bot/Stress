using Toybox.WatchUi as WatchUi;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Timer;

class StressApp extends App.AppBase {

    hidden var stressLevel = 0.0; // 0 = calm, 1 = high stress
    hidden var timerId;
    hidden var lastExercise = ""; // prevent reopening the same exercise repeatedly
    hidden var mainView; // Store reference to main view

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        // Start a timer to simulate stress changes
        timerId = new Timer.Timer();
        timerId.start(method(:simulateStress), 5000, true); // every 5 sec, repeating
    }

    function onStop(state) {
        if (timerId != null) {
            timerId.stop();
            timerId = null;
        }
    }

    function getInitialView() {
        mainView = new MainView(stressLevel);
        return [mainView, new MainViewDelegate()];
    }

    function simulateStress() as Void {
        // Random stress for testing
        stressLevel = Math.rand() % 100 / 100.0; // 0.0 to 1.0

        // Update main view if it exists
        if (mainView != null) {
            mainView.updateStress(stressLevel);
        }

        // Auto-launch exercise if stress > 0.7
        if (stressLevel > 0.7 && lastExercise != "breathing") {
            lastExercise = "breathing";
            WatchUi.pushView(new BreathingView(), new BreathingDelegate(), WatchUi.SLIDE_UP);
        } else if (stressLevel > 0.4 && stressLevel <= 0.7 && lastExercise != "grounding") {
            lastExercise = "grounding";
            var groundingView = new FiveFourThreeTwoOneView();
            WatchUi.pushView(groundingView, new FiveFourThreeTwoOneDelegate(groundingView), WatchUi.SLIDE_UP);
        } else if (stressLevel <= 0.4) {
            lastExercise = ""; // reset when stress is low
        }
    }

    function getStressLevel() {
        return stressLevel;
    }
}

function getApp() {
    return App.getApp();
}

