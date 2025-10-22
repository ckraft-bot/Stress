using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.System as Sys;

class BreathingView extends WatchUi.View {

    hidden var step = 0;
    hidden var timerId;

    function onShow() {
        step = 0;
        runBreathingCycle();
    }

    function runBreathingCycle() {
        var g = getGraphics();
        g.clear();
        var text = "";

        switch(step) {
            case 0: text = "Breathe In"; break;
            case 1: text = "Hold"; break;
            case 2: text = "Breathe Out"; break;
            case 3: text = "Hold"; break;
        }

        g.drawText(10, 30, text);
        update();

        step = (step + 1) % 4;
        timerId = Sys.Timer.start(method(:runBreathingCycle), 3000); // 3 sec per step
    }

    function onHide() {
        if (timerId != null) {
            Sys.Timer.stop(timerId);
        }
    }

    function onKey(key) {
        // Any key exits
        App.WatchApp.popView();
    }
}
