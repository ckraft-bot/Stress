using Toybox.WatchUi as WatchUi;
using Toybox.Application as App;
using Toybox.Timer;

class StressApp extends App.AppBase {
    hidden var stressLevel = 0.0;
    hidden var timerId;
    hidden var mainView;

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
        stressLevel = Math.rand() % 100 / 100.0;
        if (mainView != null) {
            mainView.updateStress(stressLevel);
        }
    }

    function getStressLevel() {
        return stressLevel;
    }
}

function getApp() {
    return App.getApp();
}
