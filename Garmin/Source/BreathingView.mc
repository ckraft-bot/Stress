using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Timer;

class BreathingView extends WatchUi.View {
    hidden var step = 0;
    hidden var timer;
    hidden var animationTimer;
    hidden var stepDuration = 4000; // 4 seconds per step
    hidden var isActive = false;
    hidden var animationProgress = 0.0;

    hidden var STEPS = [
        "Breathe In",
        "Hold",
        "Breathe Out", 
        "Hold"
    ];

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        // No layout needed
    }

    function onShow() {
        step = 0;
        isActive = true;
        startBreathingCycle();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        var instruction = STEPS[step];
        var color = getStepColor(step);
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);

        dc.drawText(
            centerX,
            centerY - 40,
            Gfx.FONT_LARGE,
            instruction,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER
        );

        var radius = getCircleRadius(step);
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY + 30, radius);

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height - 40,
            Gfx.FONT_TINY,
            "Step " + (step + 1) + " of 4",
            Gfx.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height - 20,
            Gfx.FONT_XTINY,
            "BACK to exit",
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }

    function startBreathingCycle() {
        WatchUi.requestUpdate();
        animationProgress = 0.0;

        // Reuse animation timer
        if (animationTimer == null) {
            animationTimer = new Timer.Timer();
        } else {
            animationTimer.stop();
        }
        animationTimer.start(method(:updateAnimation), 50, true);

        // Reuse step timer
        if (isActive) {
            if (timer == null) {
                timer = new Timer.Timer();
            } else {
                timer.stop();
            }
            timer.start(method(:nextStep), stepDuration, false);
        }
    }

    function updateAnimation() as Void {
        if (!isActive) { return; }

        animationProgress = animationProgress + 0.05;
        if (animationProgress > 1.0) {
            animationProgress = 1.0;
        }
        WatchUi.requestUpdate();
    }

    function nextStep() as Void {
        if (!isActive) { return; }

        step = (step + 1) % 4;
        animationProgress = 0.0;
        WatchUi.requestUpdate();

        if (timer != null) {
            timer.stop();
            timer.start(method(:nextStep), stepDuration, false);
        }
    }

    function getStepColor(currentStep) {
        if (currentStep == 0) {
            return Gfx.COLOR_BLUE;
        } else if (currentStep == 1) {
            return Gfx.COLOR_YELLOW;
        } else if (currentStep == 2) {
            return Gfx.COLOR_GREEN;
        } else {
            return Gfx.COLOR_ORANGE;
        }
    }

    function getCircleRadius(currentStep) {
        var minRadius = 15;
        var maxRadius = 40;

        if (currentStep == 0) {
            return minRadius + ((maxRadius - minRadius) * animationProgress);
        } else if (currentStep == 2) {
            return maxRadius - ((maxRadius - minRadius) * animationProgress);
        } else {
            return (currentStep == 1) ? maxRadius : minRadius;
        }
    }

    function onHide() {
        isActive = false;
        if (timer != null) {
            timer.stop();
            timer = null;
        }
        if (animationTimer != null) {
            animationTimer.stop();
            animationTimer = null;
        }
    }
}