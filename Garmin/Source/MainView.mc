// How it works
// stress is simuplated every 5 seconds
// stress > 0.7 --> trigger breathing exercise
// stress > 0.4 <=.7 --> trigger grounding exercise
// stress <= 0.4 --> no exercise


using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;

class MainView extends WatchUi.View {

    hidden var stressLevel;

    function initialize(level) {
        WatchUi.View.initialize();
        stressLevel = level;
    }

    function onShow() {
        updateDisplay();
    }

    function updateStress(level) {
        stressLevel = level;
        updateDisplay();
    }

    function updateDisplay() {
        var g = getGraphics();
        g.clear();

        var stressPercent = (stressLevel * 100).toInt();
        g.drawText(10, 10, "Stress: " + stressPercent + "%");

        if (stressLevel > 0.7) {
            g.drawText(10, 30, "High Stress — Breathing");
        } else if (stressLevel > 0.4) {
            g.drawText(10, 30, "Moderate Stress — Grounding");
        } else {
            g.drawText(10, 30, "You are calm");
        }

        update();
    }

    function onKey(key) {
        // Manual navigation still works
        if (key == WatchUi.KEY_UP) {
            App.WatchApp.pushView(new BreathingView());
        } else if (key == WatchUi.KEY_DOWN) {
            App.WatchApp.pushView(new GroundingView());
        }
    }
}
