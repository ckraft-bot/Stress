using Toybox.WatchUi as WatchUi;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Timer as Timer;
using Toybox.Graphics as Graphics;
using Toybox.Lang as Lang;

class MainView extends WatchUi.View {
    const STRICT_THRESHOLD = 70; // T1
    var pollTimer;

    function initialize() {
        WatchUi.View.initialize();
        pollTimer = new Timer.Timer();
    }

    function onShow() {
        // Start polling every 1500ms while visible (light, predictable)
        pollTimer.start(method(:onPoll), 1500, true);
        this.repaint();
    }

    function onHide() {
        pollTimer.stop();
    }

    function onPoll() {
        var info = ActivityMonitor.getInfo();
        var stress = null;
        if (info != null && info.stressScore != null) {
            stress = info.stressScore;
        }

        if (stress != null && stress >= STRICT_THRESHOLD) {
            pollTimer.stop();
            WatchUi.pushView(new PromptView(stress));
        } else {
            // keep showing UI; the onUpdate draws current value
            this.repaint();
        }
    }

    function onUpdate(dc) {
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth()/2, 8, Graphics.FONT_LARGE, "Grounding Widget", Graphics.TEXT_JUSTIFY_CENTER);

        var info = ActivityMonitor.getInfo();
        var status = "No stress data";
        if (info != null && info.stressScore != null) {
            status = "Stress: " + info.stressScore;
        }
        dc.drawText(5, 40, Graphics.FONT_MEDIUM, status);
        dc.drawText(5, 70, Graphics.FONT_SMALL, "Open to choose exercise");
    }

    // handle basic keys: select opens menu
    function onKey(key) {
        if (key == WatchUi.KEY_SELECT) {
            WatchUi.pushView(new MenuView());
        }
    }
}
