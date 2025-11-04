using Toybox.WatchUi as WatchUi;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Timer;

class StressApp extends App.AppBase {

    hidden var stressLevel = 0.0; // 0 = calm, 1 = high stress
    hidden var timerId;
    hidden var lastExercise = "";
    hidden var mainView;
    hidden var inExercise = false; // prevents repeated pushes

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        timerId = new Timer.Timer();
        timerId.start(method(:simulateStress), 5000, true);
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
        // simulate random stress
        stressLevel = Math.rand() % 100 / 100.0;

        if (mainView != null) {
            mainView.updateStress(stressLevel);
        }

        // only launch new view if not currently in one
        if (inExercise) return;

        if (stressLevel > 0.7 && lastExercise != "breathing") {
            lastExercise = "breathing";
            inExercise = true;
            WatchUi.pushView(
                new BreathingView(),
                new BreathingDelegate(method(:onExerciseComplete)),
                WatchUi.SLIDE_UP
            );
        } else if (stressLevel > 0.4 && stressLevel <= 0.7 && lastExercise != "grounding") {
            lastExercise = "grounding";
            inExercise = true;
            var groundingView = new FiveFourThreeTwoOneView();
            WatchUi.pushView(
                groundingView,
                new FiveFourThreeTwoOneDelegate(method(:onExerciseComplete)),
                WatchUi.SLIDE_UP
            );
        } else if (stressLevel <= 0.4) {
            lastExercise = "";
        }
    }

    //called by delegates when user finishes exercise
    function onExerciseComplete() as Void {
        inExercise = false;
        Sys.println("Exercise complete — ready for next one");
    }

    function getStressLevel() {
        return stressLevel;
    }
}

function getApp() {
    return App.getApp();
}
