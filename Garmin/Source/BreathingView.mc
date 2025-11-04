using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;

class BreathingView extends WatchUi.View {
    var _timer = null;
    var _step = 0;
    var _steps = ["Breathe In", "Hold", "Breathe Out", "Hold"];
    var _stepDuration = 4000; // 4 seconds

    function initialize() {
        View.initialize();
    }

    function onShow() {
        _step = 0;

        // Start ONE repeating timer for the whole cycle
        if (_timer == null) {
            _timer = new Timer.Timer();
            _timer.start(method(:nextStep), _stepDuration, true);
        }

        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;

        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(cx, cy - 20, Gfx.FONT_LARGE, _steps[_step],
                    Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, h - 20, Gfx.FONT_TINY,
                    "Step " + (_step + 1) + " of 4",
                    Gfx.TEXT_JUSTIFY_CENTER);
    }

    function nextStep() {
        _step = (_step + 1) % _steps.size();
        WatchUi.requestUpdate();
    }

    function onHide() {
        if (_timer != null) {
            _timer.stop();
            _timer = null;
        }
    }
}
