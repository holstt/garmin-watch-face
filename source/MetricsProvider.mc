import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.SensorHistory;


class BbMetricsProvider {

    hidden var _yesterdayMaxBb as SensorSample or Null;
    hidden var _yesterdayMinBb as SensorSample or Null;
    hidden var _todayMaxBb as SensorSample or Null;
    // hidden var _todayMinBb as Number or Null;
    hidden var _currentBb as SensorSample or Null;
    hidden var _lastCheckDate as Gregorian.Info = Gregorian.utcInfo(Time.now(), Time.FORMAT_MEDIUM);
    hidden var _avgMaxBb7dSamples as Array<SensorSample> = new Array<SensorSample>[0];
    hidden var _avgMaxBb7d as Number = 0;


    // Max bb is the max since midnight
    // Min bb should be after max bb. Assumed to be the most recent bb for the day atm.
    public function getMetrics(now as Moment) as BodyBatteryMetrics {
        var nowInfo = Gregorian.utcInfo(now, Time.FORMAT_MEDIUM) as Gregorian.Info;
        var midnight = Gregorian.moment({:year=>nowInfo.year, :month=>nowInfo.month, :day=>nowInfo.day}) as Moment;
        // log("Getting bb metrics from " +  toTimeString(midnight) + " to " + toTimeString(now));
        // log("Last check date: " + toTimeStringFromInfo(_lastCheckDate));

        // TODO: Test if this works as expected
        // Check if new day.
        if (_lastCheckDate.day != nowInfo.day and _todayMaxBb != null and _currentBb != null) {
            // log("New day. Storing today's max/min bb as yesterday's max/min bb");
            _yesterdayMaxBb = _todayMaxBb;
            _yesterdayMinBb = _currentBb;
            _avgMaxBb7dSamples.add(_todayMaxBb);

            // Ensure max 7 days
            if(_avgMaxBb7dSamples.size() > 7){
                // Remove the first element/oldest sample
                _avgMaxBb7dSamples = _avgMaxBb7dSamples.slice(1, null);
            }
            // Calc new average
            _avgMaxBb7d = getAvgSampleData(_avgMaxBb7dSamples);
        }

        var durationSinceMidnight = new Time.Duration(now.subtract(midnight).value());
        // printDuration(durationSinceMidnight);
        var history = SensorHistory.getBodyBatteryHistory({:period=>durationSinceMidnight, :order=>SensorHistory.ORDER_NEWEST_FIRST}) as SensorHistoryIterator;

        var historyMetrics = findBbHistoryMetrics(history);
        _currentBb = historyMetrics.newest;
        _todayMaxBb = historyMetrics.max;

        _lastCheckDate = nowInfo;


        return new BodyBatteryMetrics(_currentBb, _todayMaxBb, _yesterdayMinBb, _yesterdayMaxBb, _avgMaxBb7d);
    }

    class BbHistoryMetrics {
        public var min as SensorSample or Null;
        public var max as SensorSample or Null;
        public var newest as SensorSample or Null;

        public function initialize(min as SensorSample or Null, max as SensorSample or Null, newest as SensorSample or Null) {
            self.min = min;
            self.max = max;
            self.newest = newest;
        }
    }

    // Manually find current/min/max to get full SensorSample object.
    hidden function findBbHistoryMetrics(history as SensorHistory.SensorHistoryIterator) as BbHistoryMetrics {
        var min = null as SensorSample or Null;
        var max = null as SensorSample or Null;
        var newest = history.next();
        var sample = newest;

        // While still samples to get
        while (sample != null) {
            // Ensure valid sample
            if (sample.data != null) {
                if (max == null or sample.data > max.data) {
                    max = sample;
                }
                if (min == null or sample.data < min.data) {
                    min = sample;
                }
            }
            // Get next sample in iterator
            sample = history.next();
        }
        return new BbHistoryMetrics(min, max, newest);
    }

    // Average data value for a number of samples
    hidden function getAvgSampleData(samples as Array<SensorSample>){
        if(samples.size() == 0){
            return 0;
        }

        var sum = 0;
        for (var i = 0; i < samples.size(); i++) {
            sum += samples[i].data as Number;
        }
        return sum / samples.size();
    }
}

class HrMetricsProvider {
    // Calculate all HR metrics based on history
    // TODO: Optimization Cache HR data and only update metrics every 5 minutes (except current HR)
    public function getMetrics() as HrMetrics {
        // Get HR history for the last 24 hours
        var duration24hours = new Time.Duration(Gregorian.SECONDS_PER_DAY);

        // hr with newest first
        var hrHistory = ActivityMonitor.getHeartRateHistory(duration24hours, true);

        // Get min/max from history
        var highestHr = hrHistory.getMax() as Number or Null;
        var lowestHr = hrHistory.getMin() as Number or Null;


        // Get resting hr
        var profile = UserProfile.getProfile();
        var avgRestingHr = profile.averageRestingHeartRate as Number or Null;
        var restingHr = profile.restingHeartRate as Number or Null;

        // Get current hr
        // var currentHr = (hrHistory.next() as HeartRateSample).heartRate as Number; // Slow updates, remember to check for INVALID_HR_SAMPLE
        var currentHr = Activity.getActivityInfo().currentHeartRate as Number or Null; // Fast updates

        return new HrMetrics(currentHr, restingHr, avgRestingHr, lowestHr, highestHr);
    }
}

