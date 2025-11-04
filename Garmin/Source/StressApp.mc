import Toybox.Application as App;
import Toybox.WatchUi as WatchUi;
import Toybox.Graphics as Gfx;
import Toybox.Sensors as Sensors;
import Toybox.Activity as Activity;
import Toybox.Math as Math;

class StressApp extends App.AppBase {

    hidden var mainView;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        mainView = new StressView();
        WatchUi.pushView(mainView);
    }

    function onStop(state) {}
    function onPause() {}
    function onResume() {}
    function onExit() {}
}

class StressView extends WatchUi.View {

    hidden var rrIntervals = [];
    hidden var stressLevel = 0;
    hidden var exerciseInProgress = false;
    hidden var waitingForChoice = false;

    function onShow() {
        Sensors.startHeartRate(onSensorData);
        WatchUi.requestUpdate();
    }

    function onHide() {
        Sensors.stopHeartRate();
    }

    function onSensorData(hrm) {
        rrIntervals = hrm.getRRIntervals();
        if (rrIntervals != null && rrIntervals.size() >= 2 && !exerciseInProgress) {
            var hrv = computeHRV(rrIntervals);
            stressLevel = calculateStress(hrv);  // value between 0..1
            WatchUi.requestUpdate();
        }
    }

    function computeHRV(rrArray) {
        var sumSqDiff = 0.0;
        for (var i = 1; i < rrArray.size(); i++) {
            var diff = rrArray[i] - rrArray[i - 1];
            sumSqDiff += diff * diff;
        }
        return Math.sqrt(sumSqDiff / (rrArray.size() - 1));
    }

    function calculateStress(hrv) {
        var hrvMax = 150.0;
        var hrvMin = 20.0;
        var normalized = (hrvMax - hrv) / (hrvMax - hrvMin);
        if (normalized < 0) normalized = 0;
        if (normalized > 1) normalized = 1;
        return normalized;
    }

    // --- Check if user is currently in a workout ---
    function isUserExercising() {
        var currentActivity = Activity.getCurrent();
        if (currentActivity == null) return false;

        var type = currentActivity.getActivityType();
        var exerciseTypes = [
            Activity.ACTIVITY_RUNNING,
            Activity.ACTIVITY_CYCLING,
            Activity.ACTIVITY_SWIMMING,
            Activity.ACTIVITY_ROWING,
            Activity.ACTIVITY_HIKE
        ];

        return exerciseTypes.indexOf(type) >= 0;
    }

    // --- Mandatory grounding logic ---
    function guideGroundingExercise() {
        if (exerciseInProgress) return;
        exerciseInProgress = true;
        waitingForChoice = true;
        showExerciseChoice();
    }

    function showExerciseChoice() {
        var dc = WatchUi.getGraphicsContext();
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/3, Gfx.FONT_MEDIUM, "Choose Exercise:", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Gfx.FONT_SMALL, "SELECT: 5-4-3-2-1", Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 20, Gfx.FONT_SMALL, "DOWN: 4x4 Breathing", Gfx.TEXT_JUSTIFY_CENTER);
        WatchUi.requestUpdate();
    }

    function onKey(key) {
        if (!waitingForChoice) return;

        waitingForChoice = false;

        if (key == WatchUi.KEY_SELECT) {
            exercise54321();
        } else if (key == WatchUi.KEY_DOWN) {
            exercise4x4();
        }
    }

    // --- 5-4-3-2-1 grounding ---
    function exercise54321() {
        var steps = [
            "5 things you see",
            "4 things you touch",
            "3 things you hear",
            "2 things you smell",
            "1 thing you taste"
        ];

        for (var i = 0; i < steps.size(); i++) {
            showMessage(steps[i]);
            WatchUi.sleep(30000); // 30s per step
        }

        exerciseInProgress = false;
        WatchUi.requestUpdate();
    }

    // --- 4x4 breathing exercise ---
    function exercise4x4() {
        var phases = [
            { text: "Inhale", duration: 4000 },
            { text: "Hold", duration: 4000 },
            { text: "Exhale", duration: 4000 },
            { text: "Hold", duration: 4000 }
        ];

        for (var cycle = 0; cycle < 4; cycle++) {
            for (var i = 0; i < phases.size(); i++) {
                showMessage(phases[i].text);
                WatchUi.sleep(phases[i].duration);
            }
        }

        exerciseInProgress = false;
        WatchUi.requestUpdate();
    }

    function showMessage(msg) {
        var dc = WatchUi.getGraphicsContext();
        dc.clear();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Gfx.FONT_MEDIUM, msg, Gfx.TEXT_JUSTIFY_CENTER);
    }

    // --- Stress visualization ---
    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        var stressPercent = (stressLevel * 100).toNumber();
        dc.setColor(getStressColor(stressLevel), Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height * 0.3, Gfx.FONT_NUMBER_HOT, stressPercent.format("%d") + "%", Gfx.TEXT_JUSTIFY_CENTER);

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(centerX, height * 0.5, Gfx.FONT_SMALL, "STRESS LEVEL", Gfx.TEXT_JUSTIFY_CENTER);

        var message = getStressMessage(stressLevel);
        dc.drawText(centerX, height * 0.7, Gfx.FONT_TINY, message, Gfx.TEXT_JUSTIFY_CENTER);

        // Trigger grounding only if user is NOT exercising
        if (stressLevel > 0.5 && !exerciseInProgress && !isUserExercising()) {
            guideGroundingExercise();
        } else if (!exerciseInProgress) {
            dc.drawText(centerX, height - 20, Gfx.FONT_XTINY, "Press SELECT to check exercise", Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

    function getStressColor(level) {
        if (level > 0.7) return Gfx.COLOR_RED;
        else if (level > 0.4) return Gfx.COLOR_ORANGE;
        else return Gfx.COLOR_GREEN;
    }

    function getStressMessage(level) {
        if (level > 0.7) return "High Stress";
        else if (level > 0.4) return "Moderate Stress";
        else return "You are calm";
    }
}
