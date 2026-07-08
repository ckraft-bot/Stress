using Toybox.Application as App;
using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;
using Toybox.System as System;

class StressApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        var view = new StressView();
        var delegate = new StressInputDelegate(view);
        return [ view, delegate ];
    }

    function onStop(state) {
    }
}

class StressInputDelegate extends WatchUi.InputDelegate {

    hidden var _view;

    function initialize(viewRef) {
        InputDelegate.initialize();
        _view = viewRef;
    }

    function onSelect() {
        return _view.handleSelect();
    }

    function onDown() {
        return _view.handleDown();
    }

    function onUp() {
        return _view.handleUp();
    }
}

class StressView extends WatchUi.View {

    hidden var _controller;
    hidden var _ticker;
    hidden var _sensorAvailable;

    function initialize() {
        View.initialize();
        _controller = new StressController();
        _ticker = new Timer.Timer();
        _sensorAvailable = false;
    }

    function onShow() {
        _sensorAvailable = false;

        _ticker.start(method(:onTick), 1000, true);
        WatchUi.requestUpdate();
    }

    function onHide() {
        _ticker.stop();
    }

    function onSensorData(data) {
        _controller.onSensor(data, System.getTimer());
        WatchUi.requestUpdate();
    }

    function onTick() {
        if (!_sensorAvailable) {
            _controller.onTickWithFallback(System.getTimer());
        }
        _controller.onTick(System.getTimer());
        WatchUi.requestUpdate();
    }

    function handleSelect() {
        _controller.onSelect(System.getTimer());
        WatchUi.requestUpdate();
        return true;
    }

    function handleDown() {
        _controller.onDown(System.getTimer());
        WatchUi.requestUpdate();
        return true;
    }

    function handleUp() {
        _controller.onUp(System.getTimer());
        WatchUi.requestUpdate();
        return true;
    }

    function onUpdate(dc) {
        var model = _controller.getDisplayModel(System.getTimer());
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        dc.setColor(model[:color], Gfx.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.20, Gfx.FONT_LARGE, model[:stressLabel], Gfx.TEXT_JUSTIFY_CENTER);

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 0.40, Gfx.FONT_SMALL, model[:stateLabel], Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, h * 0.52, Gfx.FONT_SMALL, model[:confidenceLabel], Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, h * 0.64, Gfx.FONT_SMALL, model[:reasonLine], Gfx.TEXT_JUSTIFY_CENTER);

        if (model[:guidanceTitle] != null) {
            dc.drawText(cx, h * 0.76, Gfx.FONT_SMALL, model[:guidanceTitle], Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(cx, h * 0.88, Gfx.FONT_SMALL, model[:guidanceLine], Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(cx, h * 0.84, Gfx.FONT_SMALL, model[:actionHint], Gfx.TEXT_JUSTIFY_CENTER);
        }
    }
}
