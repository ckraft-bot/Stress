using Toybox.WatchUi as WatchUi;
using Toybox.Application as App;

class GroundingApp extends App.WatchApp {
    function initialize() {
        App.WatchApp.initialize();
    }

    function getInitialView() {
        return new MainView();
    }
}
