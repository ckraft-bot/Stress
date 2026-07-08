class RegulationEngine {

    hidden var _triggerThreshold;
    hidden var _sustainedWindowMs;
    hidden var _cooldownMs;

    hidden var _sustainedStartMs;
    hidden var _hasPrompt;
    hidden var _inExercise;

    hidden var _activePlan;
    hidden var _activePlanStartMs;
    hidden var _activePhaseIndex;
    hidden var _cyclesComplete;
    hidden var _awaitingFeedback;
    hidden var _cooldownUntilMs;

    function initialize() {
        _triggerThreshold = 0.65;
        _sustainedWindowMs = 5 * 60 * 1000;
        _cooldownMs = 20 * 60 * 1000;

        _sustainedStartMs = null;
        _hasPrompt = false;
        _inExercise = false;

        _activePlan = null;
        _activePlanStartMs = null;
        _activePhaseIndex = 0;
        _cyclesComplete = 0;
        _awaitingFeedback = false;
        _cooldownUntilMs = null;
    }

    function evaluate(nowMs, stressEstimate, context) {
        if (context[:state] == "exercise" || context[:state] == "recovery") {
            _sustainedStartMs = null;
            _hasPrompt = false;
            _inExercise = true;
            return;
        }

        if (_inExercise && context[:state] == "resting") {
            _inExercise = false;
        }

        if (_activePlan != null || _awaitingFeedback) {
            return;
        }

        if (_cooldownUntilMs != null && nowMs < _cooldownUntilMs) {
            return;
        }

        if (stressEstimate[:probability] >= _triggerThreshold) {
            if (_sustainedStartMs == null) {
                _sustainedStartMs = nowMs;
            }

            if ((nowMs - _sustainedStartMs) >= _sustainedWindowMs) {
                _hasPrompt = true;
            }
            return;
        }

        _sustainedStartMs = null;
        _hasPrompt = false;
    }

    function onSelect(nowMs) {
        if (_hasPrompt) {
            startPlan("resonant", nowMs);
            return;
        }

        if (_awaitingFeedback) {
            registerFeedback(true, nowMs);
        }
    }

    function onDown(nowMs) {
        if (_hasPrompt) {
            startPlan("box", nowMs);
            return;
        }

        if (_awaitingFeedback) {
            registerFeedback(false, nowMs);
        }
    }

    function onUp(nowMs) {
        if (_hasPrompt) {
            _hasPrompt = false;
            _cooldownUntilMs = nowMs + (5 * 60 * 1000);
        }
    }

    function startPlan(planName, nowMs) {
        _hasPrompt = false;
        _sustainedStartMs = null;
        _activePlan = planName;
        _activePlanStartMs = nowMs;
        _activePhaseIndex = 0;
        _cyclesComplete = 0;
    }

    function updatePlan(nowMs) {
        if (_activePlan == null) {
            return;
        }

        var sequence = getPlanSequence();
        var targetCycles = getPlanCycles();

        var elapsed = nowMs - _activePlanStartMs;
        var phaseDuration = sequence[_activePhaseIndex][:durationMs];

        if (elapsed >= phaseDuration) {
            _activePlanStartMs = nowMs;
            _activePhaseIndex += 1;

            if (_activePhaseIndex >= sequence.size()) {
                _activePhaseIndex = 0;
                _cyclesComplete += 1;
            }

            if (_cyclesComplete >= targetCycles) {
                _activePlan = null;
                _awaitingFeedback = true;
                _cooldownUntilMs = nowMs + _cooldownMs;
            }
        }
    }

    function getGuidance(nowMs) {
        if (_hasPrompt) {
            return {
                :title => "Regulate now?",
                :line => "Select Resonant  Down Box  Up Skip"
            };
        }

        if (_activePlan != null) {
            var sequence = getPlanSequence();
            var phase = sequence[_activePhaseIndex];
            var elapsed = nowMs - _activePlanStartMs;
            var secsLeft = ((phase[:durationMs] - elapsed) / 1000).toNumber();
            if (secsLeft < 0) {
                secsLeft = 0;
            }

            return {
                :title => phase[:label],
                :line => _activePlan + " cycle " + (_cyclesComplete + 1).format("%d") + "  " + secsLeft.format("%d") + "s"
            };
        }

        if (_awaitingFeedback) {
            return {
                :title => "Did this help?",
                :line => "Select Yes  Down No"
            };
        }

        return null;
    }

    function getStatusLine(nowMs) {
        if (_cooldownUntilMs != null && nowMs < _cooldownUntilMs && !_awaitingFeedback) {
            var mins = ((_cooldownUntilMs - nowMs) / 60000).toNumber();
            return "Cooldown " + mins.format("%d") + "m";
        }

        if (_sustainedStartMs != null && !_hasPrompt) {
            var seconds = ((nowMs - _sustainedStartMs) / 1000).toNumber();
            return "Sustained " + seconds.format("%d") + "s";
        }

        return "Monitoring";
    }

    function registerFeedback(helped, nowMs) {
        _awaitingFeedback = false;
        _cooldownUntilMs = nowMs + _cooldownMs;
    }

    function getPlanSequence() {
        if (_activePlan == "box") {
            return [
                { :label => "Inhale", :durationMs => 4000 },
                { :label => "Hold", :durationMs => 4000 },
                { :label => "Exhale", :durationMs => 4000 },
                { :label => "Hold", :durationMs => 4000 }
            ];
        }

        return [
            { :label => "Inhale", :durationMs => 5000 },
            { :label => "Exhale", :durationMs => 5000 }
        ];
    }

    function getPlanCycles() {
        if (_activePlan == "box") {
            return 4;
        }
        return 6;
    }
}
