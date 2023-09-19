import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.SensorHistory;

class TestMetrics {
    var bbNewestDateStr;
    var bbOldestDateStr;
    var bbNew;
    var bbOld;


}


public function getTestMetrics() as TestMetrics {

    var history = SensorHistory.getBodyBatteryHistory(null) as SensorHistory.SensorHistoryIterator;
    var newest = history.getNewestSampleTime() as Moment;
    var oldest = history.getOldestSampleTime() as Moment;

    var test = new TestMetrics();
    test.bbNewestDateStr = toTimeString(newest);
    test.bbOldestDateStr = toTimeString(oldest);


    history = SensorHistory.getBodyBatteryHistory({:order=>SensorHistory.ORDER_NEWEST_FIRST});
    var firstSample = history.next() as SensorHistory.SensorSample or Null;
    test.bbNew = Lang.format("$1$:$2$", [toTimeString(firstSample.when), firstSample.data]);
    // Get the oldest
    history = SensorHistory.getBodyBatteryHistory({:order=>SensorHistory.ORDER_OLDEST_FIRST});
    var lastSample = history.next() as SensorHistory.SensorSample or Null;
    test.bbOld = Lang.format("$1$:$2$", [toTimeString(lastSample.when), lastSample.data]);
    return test;
}