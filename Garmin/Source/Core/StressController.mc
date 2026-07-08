using Toybox.Math as Math;

class StressController {

    hidden var _baselineEngine;
    hidden var _contextDetector;
    hidden var _estimator;
    hidden var _regulation;

    hidden var _latestContext;
    hidden var _latestBaseline;
    hidden var _latestEstimate;
    hidden var _latestSnapshot;
    hidden var _fallbackPhase;

    function initialize() {
        _baselineEngine = new BaselineEngine();
        _contextDetector = new ContextDetector();
        _estimator = new StressEstimator();
        _regulation = new RegulationEngine();

        _latestContext = { :state => "resting", :suppress => false, :reason => "Boot" };
        _latestBaseline = _baselineEngine.getProfile();
        _latestEstimate = { :probability => 0.0, :confidence => "Low", :factors => ["Warmup"] };
        _latestSnapshot = null;
        _fallbackPhase = 0;
    }

    function onTickWithFallback(nowMs) {
        _fallbackPhase += 1;

        var pulse = 0;
        if ((_fallbackPhase % 40) > 24) {
            pulse = 18;
        }

        var hr = 62 + pulse;
        var rrA = 980 - (pulse * 3);
        var rrB = 955 - (pulse * 2);
        var rrC = 995 - (pulse * 3);
        var rr = [rrA, rrB, rrC, rrA];

        var mockData = { :heartRate => hr, :heartRateIntervals => rr };
        onSensor(mockData, nowMs);
    }

    function onSensor(hrm, nowMs) {
        var hr = readHeartRate(hrm);
        var rr = readRrIntervals(hrm);
        var hrv = computeRmssd(rr);

        _latestContext = _contextDetector.evaluate(nowMs, _latestSnapshot, _latestBaseline);

        _latestSnapshot = {
            :timestampMs => nowMs,
            :hr => hr,
            :rr => rr,
            :hrv => hrv,
            :hasRr => (rr != null && rr.size() >= 2)
        };

        _baselineEngine.update(_latestSnapshot, _latestContext);
        _latestBaseline = _baselineEngine.getProfile();
        _latestEstimate = _estimator.estimate(_latestSnapshot, _latestBaseline, _latestContext);
        _regulation.evaluate(nowMs, _latestEstimate, _latestContext);
    }

    function onTick(nowMs) {
        _latestContext = _contextDetector.evaluate(nowMs, _latestSnapshot, _latestBaseline);
        _regulation.updatePlan(nowMs);
        _regulation.evaluate(nowMs, _latestEstimate, _latestContext);
    }

    function onSelect(nowMs) {
        _regulation.onSelect(nowMs);
    }

    function onDown(nowMs) {
        _regulation.onDown(nowMs);
    }

    function onUp(nowMs) {
        _regulation.onUp(nowMs);
    }

    function getDisplayModel(nowMs) {
        var pct = (_latestEstimate[:probability] * 100.0).toNumber();
        var guidance = _regulation.getGuidance(nowMs);
        var color = colorFor(_latestEstimate[:probability]);

        var model = {
            :stressLabel => pct.format("%d") + "%",
            :stateLabel => "State: " + _latestContext[:state],
            :confidenceLabel => "Confidence: " + _latestEstimate[:confidence],
            :reasonLine => _latestEstimate[:factors][0],
            :guidanceTitle => null,
            :guidanceLine => null,
            :actionHint => _regulation.getStatusLine(nowMs),
            :color => color
        };

        if (guidance != null) {
            model[:guidanceTitle] = guidance[:title];
            model[:guidanceLine] = guidance[:line];
            model[:actionHint] = "";
        }

        return model;
    }

    function readHeartRate(hrm) {
        if (hrm == null) {
            return null;
        }

        if (hrm has :heartRate) {
            return hrm[:heartRate];
        }

        if (hrm has :currentHeartRate) {
            return hrm[:currentHeartRate];
        }

        if (hrm has :getHeartRate) {
            return hrm.getHeartRate();
        }

        if (hrm has :heartRate) {
            return hrm.heartRate;
        }

        return null;
    }

    function readRrIntervals(hrm) {
        if (hrm == null) {
            return null;
        }

        if (hrm has :heartRateIntervals) {
            return hrm[:heartRateIntervals];
        }

        if (hrm has :rrIntervals) {
            return hrm[:rrIntervals];
        }

        if (hrm has :getRRIntervals) {
            return hrm.getRRIntervals();
        }

        return null;
    }

    function computeRmssd(rrArray) {
        if (rrArray == null || rrArray.size() < 2) {
            return null;
        }

        var sumSqDiff = 0.0;
        for (var i = 1; i < rrArray.size(); i += 1) {
            var diff = rrArray[i] - rrArray[i - 1];
            sumSqDiff += diff * diff;
        }

        return Math.sqrt(sumSqDiff / (rrArray.size() - 1));
    }

    function colorFor(probability) {
        if (probability >= 0.7) {
            return 0xFF0000;
        }

        if (probability >= 0.45) {
            return 0xFF9A00;
        }

        return 0x00CC66;
    }
}
