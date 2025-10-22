using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.System as Sys;

class GroundingView extends WatchUi.View {

    hidden var step = 1;
    hidden var timerId;

    function onShow() {
        step = 1;
        showStep();
    }

    function showStep() {
        var g = getGraphics();
        g.clear();
        g.drawText(10, 30, "Grounding Step " + step + "/5");
        update();

        step += 1;
        if (step <= 5) {
            timerId = Sys.Timer.start(method(:showStep), 5000); // 5 sec per step
        } else {
            g.drawText(10, 50, "Finished — Well done!");
            update();
        }
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
