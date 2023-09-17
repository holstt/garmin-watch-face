
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
using Toybox.Time;

class HrMetrics {
    public var currentHr as Number or Null;

    // current resting hr
    public var restingHr as Number or Null;
    // 7-day average resting hr
    public var avgRestingHr as Number or Null;
    public var lowHr as Number or Null;
    public var highHr as Number or Null;

    public function initialize(currentHr as Number or Null, restingHr as Number or Null, avgRestingHr as Number or Null, lowHr as Number or Null, highHr as Number or Null) {
        self.currentHr = currentHr;
        self.restingHr = restingHr;
        self.lowHr = lowHr;
        self.highHr = highHr;
        self.avgRestingHr = avgRestingHr;
    }


}