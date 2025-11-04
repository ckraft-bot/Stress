using Toybox.WatchUi as WatchUi;

// This will replace your previous getInitialView() so that MainView is paired with its delegate.
class MainViewDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Triggered when user presses MENU button
    function onMenu() {
        openMenu();
        return true;
    }

    // Triggered when user presses SELECT button
    function onSelect() {
        openMenu();
        return true;
    }

    hidden function openMenu() {
        var menuView = new MenuView();
        WatchUi.pushView(menuView, new MenuViewDelegate(menuView), WatchUi.SLIDE_UP);
    }
}
