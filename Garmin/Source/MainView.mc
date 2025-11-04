using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

class MainView extends WatchUi.View {

    hidden var stressLevel;

    function initialize(level) {
        View.initialize();
        stressLevel = level;
    }

    function onLayout(dc) {
        // No layout file needed for simple view
    }

    function onShow() {
        WatchUi.requestUpdate();
    }

    function updateStress(level) {
        stressLevel = level;
        WatchUi.requestUpdate(); // Request a redraw
    }

    function onUpdate(dc) {
        // Get device dimensions
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        
        // Clear the screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        // Draw stress percentage
        var stressPercent = (stressLevel * 100).toNumber().toNumber();
        dc.setColor(getStressColor(stressLevel), Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height * 0.3,
            Gfx.FONT_NUMBER_HOT,
            stressPercent.format("%d") + "%",
            Gfx.TEXT_JUSTIFY_CENTER
        );

        // Draw stress label
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height * 0.5,
            Gfx.FONT_SMALL,
            "STRESS LEVEL",
            Gfx.TEXT_JUSTIFY_CENTER
        );

        // Draw status message
        var message = getStressMessage(stressLevel);
        dc.drawText(
            centerX,
            height * 0.7,
            Gfx.FONT_TINY,
            message,
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }

    function getStressColor(level) {
        if (level > 0.7) {
            return Gfx.COLOR_RED;
        } else if (level > 0.4) {
            return Gfx.COLOR_ORANGE;
        } else {
            return Gfx.COLOR_GREEN;
        }
    }

    function getStressMessage(level) {
        if (level > 0.7) {
            return "High Stress\nBreathing Exercise";
        } else if (level > 0.4) {
            return "Moderate Stress\nGrounding Exercise";
        } else {
            return "You are calm";
        }
    }
}

class MainViewDelegate extends WatchUi.BehaviorDelegate {
    
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        var menuView = new MenuView();
        WatchUi.pushView(menuView, new MenuViewDelegate(menuView), WatchUi.SLIDE_UP);
        return true;
    }

    function onSelect() {
        var menuView = new MenuView();
        WatchUi.pushView(menuView, new MenuViewDelegate(menuView), WatchUi.SLIDE_UP);
        return true;
    }
}