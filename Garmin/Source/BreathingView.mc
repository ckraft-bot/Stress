using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BreathingView extends WatchUi.View {
    hidden var step = 0;
    hidden var timer;
    hidden var animationTimer;
    hidden var stepDuration = 4000; // 4 seconds per step
    hidden var isActive = false;
    hidden var animationProgress = 0.0;
    
    hidden const STEPS = [
        WatchUi.loadResource(Rez.Strings.breathe_in),
        WatchUi.loadResource(Rez.Strings.hold),
        WatchUi.loadResource(Rez.Strings.breathe_out),
        WatchUi.loadResource(Rez.Strings.hold)
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

        // Clear screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        // Get current instruction
        var instruction = STEPS[step];
        
        // Set color based on step
        var color = getStepColor(step);
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);

        // Draw breathing instruction
        dc.drawText(
            centerX,
            centerY - 40,
            Gfx.FONT_LARGE,
            instruction,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER
        );

        // Draw visual circle that "breathes"
        var radius = getCircleRadius(step);
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY + 30, radius);

        // Draw step counter
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height - 40,
            Gfx.FONT_TINY,
            "Step " + (step + 1) + " of 4",
            Gfx.TEXT_JUSTIFY_CENTER
        );

        // Draw exit instruction
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
        
        // Faster updates for smooth animation
        animationtimer = new Sys.Timer();
        animationTimer.start(method(:updateAnimation), 50, true); // 50ms updates
        
        // Step timer
        if (isActive) {
            timer = new Sys.Timer();
            timer.start(method(:nextStep), stepDuration, false);
        }
    }

    function updateAnimation() {
        if (!isActive) { return; }
        
        animationProgress += 0.05;
        if (animationProgress > 1.0) {
            animationProgress = 1.0;
        }
        WatchUi.requestUpdate();
    }

    function nextStep() {
        if (!isActive) { return; }
        
        step = (step + 1) % 4;
        animationProgress = 0.0;
        WatchUi.requestUpdate();
        
        timer = new Sys.Timer();
        timer.start(method(:nextStep), stepDuration, false);
    }

    function getStepColor(currentStep) {
        switch(currentStep) {
            case 0: return Gfx.COLOR_BLUE;    // Breathe In
            case 1: return Gfx.COLOR_YELLOW;  // Hold
            case 2: return Gfx.COLOR_GREEN;   // Breathe Out
            case 3: return Gfx.COLOR_ORANGE;  // Hold
        }
        return Gfx.COLOR_WHITE;
    }

    function getCircleRadius(currentStep) {
        var minRadius = 15;
        var maxRadius = 40;
        
        if (currentStep == 0) { // Breathe In - grow
            return minRadius + ((maxRadius - minRadius) * animationProgress);
        } else if (currentStep == 2) { // Breathe Out - shrink
            return maxRadius - ((maxRadius - minRadius) * animationProgress);
        } else { // Hold - stay same
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

class BreathingDelegate extends WatchUi.BehaviorDelegate {
    
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onSelect() {
        // Also allow select to exit
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}