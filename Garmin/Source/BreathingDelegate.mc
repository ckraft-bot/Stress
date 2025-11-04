using Toybox.WatchUi as WatchUi;
using Toybox.System as Sys;

class BreathingDelegate extends WatchUi.BehaviorDelegate {
    hidden var callback;

    function initialize(cb) {
        BehaviorDelegate.initialize();
        callback = cb;
    }

    function onHide() {
        if (callback != null) {
            callback();
        }
    }
}
