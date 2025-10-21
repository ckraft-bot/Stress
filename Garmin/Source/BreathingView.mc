using Toybox.WatchUi as WatchUi;
using Toybox.Timer as Timer;
using Toybox.Graphics as Graphics;
using Toybox.Attention as Attention;

class BreathingView extends WatchUi.View {
    var stage = 0; // 0: inhale, 1: hold, 2: exhale, 3: hold
    var timer;
    const stageLabel = ["Inhale", "Hold", "Exhale", "Hold"];
    const stageMillis = [4000, 4000, 4000, 4000]; // 4 seconds each

    function initialize() {
        WatchUi.View.initialize();
        timer = new Timer.Timer();
    }

    function onShow() {
        startStage(0);
    }

    function onHide() {
        if (timer) timer.stop();
    }

    function startStage(s) {
        stage = s;
        this.repaint();

        // Trigger vibration cue at the start of each stage
        triggerVibration();

        timer.start(method(:onStageComplete), stageMillis[stage], false);
    }

    function onStageComplete() {
        var next = (stage + 1) % 4;
        startStage(next);
    }

    function triggerVibration() {
        try {
            // Define a simple vibration profile
            var vibeProfile = new Attention.VibeProfile(100, 500); // 100% duty cycle for 500ms
            Attention.vibrate([vibeProfile]);
        } catch (e) {
            // Handle any errors gracefully
        }
    }

    function onUpdate(dc) {
        dc.clear();
        dc.drawText(dc.getWidth()/2, 6, Graphics.FONT_MEDIUM, "Box Breathing", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, 40, Graphics.FONT_LARGE, stageLabel[stage], Graphics.TEXT_JUSTIFY_CENTER);

        // Simple countdown hint (not exact remaining ms)
        dc.drawText(5, dc.getHeight()-20, Graphics.FONT_SMALL, "Press BACK to end");
    }

    function onKey(key) {
        if (key == WatchUi.KEY_BACK) {
            WatchUi.popView();
        }
    }
}
