using Toybox.WatchUi as WatchUi;
using Toybox.Application as App;
using Toybox.System as Sys;

class StressApp extends App.WatchApp {

    hidden var stressLevel = 0.0; // 0 = calm, 1 = high stress
    hidden var timerId;
    hidden var lastExercise = ""; // prevent reopening the same exercise repeatedly

    function initialize() {
        App.WatchApp.initialize();
    }

    function getInitialView() {
        // Start a timer to simulate stress changes
        timerId = Sys.Timer.repeat(method(:simulateStress), 5000); // every 5 sec
        return new MainView(stressLevel);
    }

    function simulateStress() {
        // Random stress for testing
        stressLevel = Math.random(); // 0.0 to 1.0

        var view = getCurrentView();
        if (view != null && view.hasMethod("updateStress")) {
            view.updateStress(stressLevel);
        }

        // Auto-launch exercise if stress > 0.7
        if (stressLevel > 0.7 && lastExercise != "breathing") {
            lastExercise = "breathing";
            App.WatchApp.pushView(new BreathingView());
        } else if (stressLevel > 0.4 && stressLevel <= 0.7 && lastExercise != "grounding") {
            lastExercise = "grounding";
            App.WatchApp.pushView(new GroundingView());
        } else if (stressLevel <= 0.4) {
            lastExercise = ""; // reset when stress is low
        }
    }
}
