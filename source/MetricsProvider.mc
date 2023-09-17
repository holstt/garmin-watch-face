import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
using Toybox.Time;

class MetricsProvider {
    // Calculate all HR metrics based on history
    // TODO: Optimization Cache HR data and only update metrics every 5 minutes (except current HR)
    public function getHrMetrics() as HrMetrics {
        // Get min/max from history
        // Get HR history for the last 24 hours
        var HOURS_24 = 60 * 60 * 24;
        var duration24hours = new Time.Duration(HOURS_24);
        // hr with newest first
        var hrHistory = ActivityMonitor.getHeartRateHistory(duration24hours, true);

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

