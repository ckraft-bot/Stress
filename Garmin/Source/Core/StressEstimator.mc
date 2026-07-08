class StressEstimator {

    function initialize() {
    }

    function estimate(snapshot, baseline, context) {
        if (snapshot == null || baseline == null || context == null) {
            return {
                :probability => 0.0,
                :confidence => "Low",
                :factors => ["Waiting for data"]
            };
        }

        if (context[:suppress]) {
            return {
                :probability => 0.0,
                :confidence => "Low",
                :factors => [context[:reason]]
            };
        }

        var factors = [];
        var score = 0.0;

        if (snapshot[:hrv] != null) {
            var hrvChangePct = ((baseline[:hrv] - snapshot[:hrv]) * 100.0) / maxFloat(1.0, baseline[:hrv]);
            if (hrvChangePct > 10.0) {
                score += clamp(hrvChangePct / 70.0, 0.0, 0.6);
                factors.add("HRV below baseline");
            }
        }

        if (snapshot[:hr] != null) {
            var restingHrDelta = snapshot[:hr] - baseline[:hr];
            if (restingHrDelta > 5.0) {
                score += clamp(restingHrDelta / 40.0, 0.0, 0.35);
                factors.add("Heart rate above baseline");
            }
        }

        if (!snapshot[:hasRr]) {
            score = score * 0.7;
            factors.add("No RR intervals available");
        }

        if (factors.size() == 0) {
            factors.add("Within expected baseline range");
        }

        return {
            :probability => clamp(score, 0.0, 1.0),
            :confidence => confidenceFor(snapshot, baseline),
            :factors => factors
        };
    }

    function confidenceFor(snapshot, baseline) {
        if (baseline[:samples] >= 60 && snapshot[:hasRr]) {
            return "High";
        }

        if (baseline[:samples] >= 20) {
            return "Medium";
        }

        return "Low";
    }

    function clamp(value, minValue, maxValue) {
        if (value < minValue) {
            return minValue;
        }
        if (value > maxValue) {
            return maxValue;
        }
        return value;
    }

    function maxFloat(a, b) {
        if (a > b) {
            return a;
        }
        return b;
    }
}
