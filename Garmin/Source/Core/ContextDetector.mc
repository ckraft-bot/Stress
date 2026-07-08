class ContextDetector {

    hidden var _recoveryWindowMs;
    hidden var _inExercise;
    hidden var _lastExerciseEndMs;

    function initialize() {
        _recoveryWindowMs = 20 * 60 * 1000;
        _inExercise = false;
        _lastExerciseEndMs = null;
    }

    function evaluate(nowMs, snapshot, baseline) {
        var exercising = isLikelyExercise(snapshot, baseline);

        if (exercising) {
            _inExercise = true;
            return {
                :state => "exercise",
                :suppress => true,
                :reason => "Exercise detected"
            };
        }

        if (_inExercise) {
            _inExercise = false;
            _lastExerciseEndMs = nowMs;
        }

        if (_lastExerciseEndMs != null) {
            var delta = nowMs - _lastExerciseEndMs;
            if (delta < _recoveryWindowMs) {
                var minsLeft = ((_recoveryWindowMs - delta) / 60000).toNumber();
                return {
                    :state => "recovery",
                    :suppress => true,
                    :reason => "Post-workout recovery " + minsLeft.format("%d") + "m"
                };
            }
        }

        return {
            :state => "resting",
            :suppress => false,
            :reason => "Resting context"
        };
    }

    function isLikelyExercise(snapshot, baseline) {
        if (snapshot == null || baseline == null) {
            return false;
        }

        if (snapshot[:hr] == null || baseline[:hr] == null) {
            return false;
        }

        // Heuristic for exercise suppression on SDKs where explicit workout APIs are unavailable.
        return snapshot[:hr] >= (baseline[:hr] + 30);
    }
}
