using Toybox.WatchUi as WatchUi;

class MainViewDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Optional: handle back button or other app-wide behaviors
    function onBack() {
        return false; // let the system handle back
    }

    function onKey(key, state) {
        // You can intercept keys here if needed
        return false;
    }
}
