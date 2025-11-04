using Toybox.WatchUi as WatchUi;
using Toybox.Application as App;
using Toybox.Timer as Timer;
using Toybox.System as Sys;

class StressApp extends App.AppBase {

    hidden var stressLevel = 0.0;   // 0 = calm, 1 = high stress
    hidden var timerId;
    hidden var mainView;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        // Timer to simulate stress changes
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
        return [mainView, new MainViewDelegate()]; // delegate handles menu/select
    }

    function simulateStress() as Void {
        // simulate random stress
        stressLevel = Math.rand() % 100 / 100.0;

        if (mainView != null) {
            mainView.updateStress(stressLevel);
        }

        // no automatic launching of exercises
    }

    function getStressLevel() {
        return stressLevel;
    }
}

function getApp() {
    return App.getApp();
}
