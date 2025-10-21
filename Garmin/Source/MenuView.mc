using Toybox.WatchUi as WatchUi;
using Toybox.Graphics as Graphics;

class MenuView extends WatchUi.View {
    var cursor = 0;
    const items = [ "Breathing", "5-4-3-2-1" ];

    function initialize() {
        WatchUi.View.initialize();
    }

    function onShow() {
        this.repaint();
    }

    function onUpdate(dc) {
        dc.clear();
        dc.drawText(dc.getWidth()/2, 6, Graphics.FONT_MEDIUM, "Choose Exercise", Graphics.TEXT_JUSTIFY_CENTER);

        for (var i = 0; i < items.size(); i++) {
            var y = 30 + i*24;
            var prefix = (i == cursor) ? "▶ " : "  ";
            dc.drawText(5, y, Graphics.FONT_SMALL, prefix + items[i]);
        }

        dc.drawText(5, dc.getHeight()-20, Graphics.FONT_SMALL, "Select = Start");
    }

    function onKey(key) {
        if (key == WatchUi.KEY_UP) {
            cursor = Math.max(0, cursor - 1);
            this.repaint();
        } else if (key == WatchUi.KEY_DOWN) {
            cursor = Math.min(items.size()-1, cursor + 1);
            this.repaint();
        } else if (key == WatchUi.KEY_SELECT) {
            if (cursor == 0) {
                WatchUi.pushView(new BreathingView());
            } else {
                WatchUi.pushView(new FiveFourThremoeTwoOne(1));
            }
        } else if (key == WatchUi.KEY_BACK) {
            WatchUi.popView();
        }
    }
}
