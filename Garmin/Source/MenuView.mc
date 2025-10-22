using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Gfx;

class MenuView extends WatchUi.View {
    hidden var cursor = 0;
    hidden const items = ["Breathing", "5-4-3-2-1"];

    function initialize() {
        View.initialize();
    }

    function onShow() {
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;

        // Clear screen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        // Draw title
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height * 0.15,
            Gfx.FONT_MEDIUM,
            "Choose Exercise",
            Gfx.TEXT_JUSTIFY_CENTER
        );

        // Draw menu items
        var startY = height * 0.35;
        var itemSpacing = height * 0.15;

        for (var i = 0; i < items.size(); i++) {
            var y = startY + (i * itemSpacing);
            var isSelected = (i == cursor);

            // Highlight selected item
            if (isSelected) {
                dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
                dc.fillRectangle(10, y - 5, width - 20, 30);
                dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
            }

            var prefix = isSelected ? "▶ " : "   ";
            dc.drawText(
                centerX,
                y,
                Gfx.FONT_SMALL,
                prefix + items[i],
                Gfx.TEXT_JUSTIFY_CENTER
            );
        }

        // Draw instruction
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            centerX,
            height * 0.85,
            Gfx.FONT_XTINY,
            "SELECT to start",
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }

    function moveCursor(direction) {
        if (direction == :up) {
            cursor = (cursor - 1 + items.size()) % items.size();
        } else if (direction == :down) {
            cursor = (cursor + 1) % items.size();
        }
        WatchUi.requestUpdate();
    }

    function selectItem() {
        if (cursor == 0) {
            WatchUi.pushView(
                new BreathingView(),
                new BreathingDelegate(),
                WatchUi.SLIDE_UP
            );
        } else if (cursor == 1) {
            var groundingView = new FiveFourThreeTwoOneView();
            WatchUi.pushView(
                groundingView,
                new FiveFourThreeTwoOneDelegate(groundingView),
                WatchUi.SLIDE_UP
            );
        }
        return true;
    }
}

class MenuViewDelegate extends WatchUi.BehaviorDelegate {
    hidden var view;

    function initialize(menuView) {
        BehaviorDelegate.initialize();
        view = menuView;
    }

    function onNextPage() {
        // Swipe up or UP button
        view.moveCursor(:down);
        return true;
    }

    function onPreviousPage() {
        // Swipe down or DOWN button
        view.moveCursor(:up);
        return true;
    }

    function onSelect() {
        // Middle button or tap
        return view.selectItem();
    }

    function onBack() {
        // Back button
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}