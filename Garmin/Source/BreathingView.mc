using Toybox.WatchUi as WatchUi;
using Toybox.Timer as Timer;

class BreathingView extends WatchUi.View {

    var _timer = null;
    var _step = 0;

    function onShow() {
        nextStep();
    }

    function onHide() {
        if (_timer != null) {
            _timer.cancel();
            _timer = null;
        }
    }

    function nextStep() {
        if (_timer != null) {
            _timer.cancel();
            _timer = null;
        }

        if (_step == 0) {
            System.println("Breathe in...");
        } else if (_step == 1) {
            System.println("Hold...");
        } else if (_step == 2) {
            System.println("Breathe out...");
        } else {
            _step = -1;
        }

        if (_step >= 0) {
            _timer = Timer.Timer();
            _timer.start(method(:nextStep), 4000);
        }

        _step += 1;
    }
}
