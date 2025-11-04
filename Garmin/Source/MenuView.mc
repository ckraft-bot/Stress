using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;

class MenuView extends WatchUi.View {
    hidden var stressLevel;

    function initialize(level) {
        View.initialize();
        stressLevel = level;
    }

    function onLayout(dc) { }

    function onShow() {
        WatchUi.requestUpdate();
    }

    function updateStress(level) {
        stressLevel = level;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        var stressPercent = (stressLevel * 100).toNumber();
        dc.setColor(getStressColor(stressLevel), Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height*0.3, Gfx.FONT_NUMBER_HOT, stressPercent.format("%d") + "%", Gfx.TEXT_JUSTIFY_CENTER);

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height*0.5, Gfx.FONT_SMALL, "STRESS LEVEL", Gfx.TEXT_JUSTIFY_CENTER);

        var message = getStressMessage(stressLevel);
        dc.drawText(centerX, height*0.7, Gfx.FONT_TINY, message, Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(centerX, height - 20, Gfx.FONT_XTINY, "Select exercise from menu", Gfx.TEXT_JUSTIFY_CENTER);
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
            return "High Stress";
        } else if (level > 0.4) {
            return "Moderate Stress";
        } else {
            return "You are calm";
        }
    }

    // --- Button handlers ---
    function onSelect() {
        // Add your menu interaction logic here
        return true;
    }

    function onMenu() {
        return onSelect();
    }
}

class MenuViewDelegate extends WatchUi.BehaviorDelegate {
    function initialize(view) {
        BehaviorDelegate.initialize();
    }
}