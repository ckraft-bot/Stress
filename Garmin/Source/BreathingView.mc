using Toybox.Timer as Timer;
using Toybox.System as Sys;

class BreathingView extends WatchUi.View {
    var _timer;
    var _step = 0;

    const STEP_DURATION = 4000;
    const STEPS = ["Breathe In", "Hold", "Breathe Out", "Hold"];

    function initialize() {
        View.initialize();
        _timer = new Timer.Timer(); // create once
    }

    function onShow() {
        _step = 0;
        runStep();
    }

    function onHide() {
        if (_timer != null) {
            _timer.stop();
        }
    }

    function runStep() {
        // display/log current step
        Sys.println(STEPS[_step]);

        // schedule next step
        _timer.stop(); // safety — ensures only one active
        _timer.start(method(:nextStep), STEP_DURATION, false);
    }

    function nextStep() {
        _step = (_step + 1) % STEPS.size(); // loop back after 4
        runStep();
    }
}
