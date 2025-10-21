import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class stress_garmin_newApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new stress_garmin_newView(), new stress_garmin_newDelegate() ];
    }

}

function getApp() as stress_garmin_newApp {
    return Application.getApp() as stress_garmin_newApp;
}