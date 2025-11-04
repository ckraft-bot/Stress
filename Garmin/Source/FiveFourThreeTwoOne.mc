using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;
using Toybox.System as Sys;

class FiveFourThreeTwoOneView extends WatchUi.View {

    hidden var _steps = ["5", "4", "3", "2", "1"];
    hidden var _index = 0;
    hidden var _timer = null;
    hidden var _delegate;

    function initialize(delegate) {
        View.initialize();
        _delegate = delegate;
    }

    function onShow() {
        _index = 0;
        nextStep();
    }

    function onHide() {
        // Cancel timer if leaving view
        if (_timer != null) {
            _timer.cancel();
            _timer = null;
        }
    }

    function nextStep() {
        // Cancel previous timer
        if (_timer != null) {
            _timer.cancel();
            _timer = null;
        }

        if (_index < _steps.size()) {
            WatchUi.requestUpdate();
            Sys.println("Step: " + _steps[_index]);
            _timer = Timer.Timer();
            // Wait 1 second per step
            _timer.start(method(:nextStep), 1000);
            _index += 1;
        } else {
            // Exercise complete
            if (_delegate != null && _delegate.respondsTo("onExerciseComplete")) {
                _delegate.onExerciseComplete();
            }
            // Go back to main view
            WatchUi.popView();
        }
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        if (_index < _steps.size()) {
            var stepText = _steps[_index];
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX, height / 2, Gfx.FONT_NUMBER_HOT, stepText, Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(centerX, height / 2, Gfx.FONT_SMALL, "Done!", Gfx.TEXT_JUSTIFY_CENTER);
        }
    }
}

// Simple delegate to notify the main app
class FiveFourThreeTwoOneDelegate extends WatchUi.BehaviorDelegate {

    hidden var _callback;

    function initialize(callback) {
        BehaviorDelegate.initialize();
        _callback = callback;
    }

    function onExerciseComplete() {
        if (_callback != null) {
            _callback();
        }
    }
}
