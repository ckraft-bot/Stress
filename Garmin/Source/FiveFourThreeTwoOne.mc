using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;

class FiveFourThreeTwoOne extends WatchUi.View {
    var stepNum;
    const steps = [
      "Name 5 things you can see.",
      "Name 4 things you can touch.",
      "Name 3 things you can hear.",
      "Name 2 things you can smell.",
      "Name 1 thing you can taste or a calming sentence."
    ];

    function initialize(n) {
        WatchUi.View.initialize();
        stepNum = Math.max(1, Math.min(5, n));
    }

    function onShow() {
        this.repaint();
    }

    function onUpdate(dc) {
        dc.clear();
        dc.drawText(dc.getWidth()/2, 6, Graphics.FONT_MEDIUM, "Grounding (" + stepNum + "/5)", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawWrapText(5, 28, dc.getWidth()-10, Graphics.FONT_SMALL, steps[stepNum-1]);
        dc.drawText(5, dc.getHeight()-20, Graphics.FONT_SMALL, "Select = Next");
    }

    function onKey(key) {
        if (key == WatchUi.KEY_SELECT) {
            if (stepNum < 5) {
                WatchUi.pushView(new GroundingStepView(stepNum + 1));
            } else {
                // finished — show a small finish message and pop back to main
                WatchUi.pushView(new FinishedView());
            }
        } else if (key == WatchUi.KEY_BACK) {
            WatchUi.popView();
        }
    }
}

class FinishedView extends WatchUi.View {
    function initialize() {
        WatchUi.View.initialize();
    }

    function onShow() {
        this.repaint();
    }

    function onUpdate(dc) {
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 8, Graphics.FONT_MEDIUM, "Finished", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 10, Graphics.FONT_SMALL, "Well done", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onKey(key) {
        if (key == WatchUi.KEY_BACK || key == WatchUi.KEY_SELECT) {
            // pop two views back to the main (or just pop once depending on stack)
            WatchUi.popView(); // pop FinishedView
            WatchUi.popView(); // pop previous grounding view
        }
    }
}
