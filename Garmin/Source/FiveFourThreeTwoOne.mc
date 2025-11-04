using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class FiveFourThreeTwoOneView extends WatchUi.View {
    hidden var step = 0;
    hidden var timer;
    hidden var isActive = false;
    hidden var stepDuration = 8000; // 8 seconds per step
    
    // 5-4-3-2-1 Grounding technique
    hidden const STEPS = [
        "Name 5 things\nyou can SEE",
        "Name 4 things\nyou can TOUCH",
        "Name 3 things\nyou can HEAR",
        "Name 2 things\nyou can SMELL",
        "Name 1 thing\nyou can TASTE"
    ];

    hidden const STEP_COUNTS = [5, 4, 3, 2, 1];

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        // No layout needed
    }

    function onShow() {
        step = 0;
        isActive = true;
        WatchUi.requestUpdate();
        startTimer();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;

        // Clear screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        if (step < STEPS.size()) {
            // Draw large number
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(
                centerX,
                height * 0.2,
                Gfx.FONT_NUMBER_HOT,
                STEP_COUNTS[step].toString(),
                Gfx.TEXT_JUSTIFY_CENTER
            );

            // Draw instruction
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(
                centerX,
                centerY - 10,
                Gfx.FONT_SMALL,
                STEPS[step],
                Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER
            );

            // Draw progress
            dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
            dc.drawText(
                centerX,
                height * 0.8,
                Gfx.FONT_TINY,
                "Step " + (step + 1) + " of 5",
                Gfx.TEXT_JUSTIFY_CENTER
            );

            // Draw progress bar
            var barWidth = width * 0.8;
            var barHeight = 6;
            var barX = (width - barWidth) / 2;
            var barY = height * 0.9;
            
            dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(barX, barY, barWidth, barHeight);
            
            var progress = (step + 1).toFloat() / STEPS.size();
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(barX, barY, barWidth * progress, barHeight);

        } else {
            // Completion screen
            dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
            dc.drawText(
                centerX,
                centerY - 30,
                Gfx.FONT_LARGE,
                "Complete!",
                Gfx.TEXT_JUSTIFY_CENTER
            );

            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(
                centerX,
                centerY + 20,
                Gfx.FONT_SMALL,
                "Well done!",
                Gfx.TEXT_JUSTIFY_CENTER
            );
        }

        // Draw exit instruction
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height - 15,
            Gfx.FONT_XTINY,
            "BACK to exit",
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }

    function startTimer() {
        if (isActive && step < STEPS.size()) {
            timer = new Sys.Timer();
            timer.start(method(:nextStep), stepDuration, false);
        }
    }

    function nextStep() {
        if (!isActive) {
            return;
        }

        step = step + 1;
        WatchUi.requestUpdate();

        if (step < STEPS.size()) {
            startTimer();
        } else {
            // Exercise complete - auto-exit after 3 seconds
            timer = new Sys.Timer();
            timer.start(method(:autoExit), 3000, false);
        }
    }

    function autoExit() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onHide() {
        isActive = false;
        if (timer != null) {
            timer.stop();
            timer = null;
        }
    }
}

class FiveFourThreeTwoOneDelegate extends WatchUi.BehaviorDelegate {
    hidden var view;

    function initialize(groundingView) {
        BehaviorDelegate.initialize();
        view = groundingView;
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onSelect() {
        // Tap to advance to next step
        if (view != null) {
            view.nextStep();
        }
        return true;
    }

    function onNextPage() {
        // Swipe up to advance
        if (view != null) {
            view.nextStep();
        }
        return true;
    }
}