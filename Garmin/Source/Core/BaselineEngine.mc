class BaselineEngine {

    hidden var _hrvValues;
    hidden var _hrValues;
    hidden var _maxSamples;

    function initialize() {
        _hrvValues = [];
        _hrValues = [];
        _maxSamples = 180;
    }

    function update(snapshot, context) {
        if (snapshot == null || context == null) {
            return;
        }

        if (context[:state] != "resting") {
            return;
        }

        if (snapshot[:hrv] != null) {
            _hrvValues.add(snapshot[:hrv]);
            trimToMax(_hrvValues);
        }

        if (snapshot[:hr] != null) {
            _hrValues.add(snapshot[:hr]);
            trimToMax(_hrValues);
        }
    }

    function getProfile() {
        return {
            :hrv => safeMean(_hrvValues, 55.0),
            :hr => safeMean(_hrValues, 65.0),
            :samples => minInt(_hrvValues.size(), _hrValues.size())
        };
    }

    function trimToMax(arr) {
        while (arr.size() > _maxSamples) {
            arr.remove(0);
        }
    }

    function safeMean(arr, fallback) {
        if (arr == null || arr.size() == 0) {
            return fallback;
        }

        var sum = 0.0;
        for (var i = 0; i < arr.size(); i += 1) {
            sum += arr[i];
        }
        return sum / arr.size();
    }

    function minInt(a, b) {
        if (a < b) {
            return a;
        }
        return b;
    }
}
