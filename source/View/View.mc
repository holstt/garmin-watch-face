import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
using Toybox.Time;

function log(msg as String) {
    System.println(msg);
}



class View extends WatchUi.WatchFace {

	hidden var height;
    hidden var width;
    hidden var centerX;
	hidden var centerY;

    hidden var _hrView;
    hidden var _highLowHrView;
    hidden var _timeLabel;
    hidden var _restingHrView;
    hidden var _bbView;

    hidden var _hrProvider;
    hidden var _bbProvider;

    function initialize() {
        WatchFace.initialize();
        _hrProvider = new HrMetricsProvider();
        _bbProvider = new BbMetricsProvider();

        System.println("Initialized");
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        System.println("OnLayout");

        height = dc.getHeight();
        width = dc.getWidth();
        centerX = width / 2;
        centerY = height / 2;

        var res = new ResLoader();

        _timeLabel = createTimeLabel();
        _hrView = new CurrentHrView(res.iconHr);
        _highLowHrView = new HighLowHrView(res.iconUp, res.iconDown);
        _restingHrView = new RestingHrView();
        _bbView = new BbView(res.iconBb);

        setLayout(Rez.Layouts.WatchFace(dc));
    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        System.println("OnShow");
    }


    // Update the view.
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        // NB: Calls to dc before this will be overwritten!
        View.onUpdate(dc);

        var now = Time.now();

        // var testMetrics = metricsProvider.getTestMetrics();
        // new Text({
        //     :text=>testMetrics.bbNewestDateStr,
        //     :color=>Graphics.COLOR_WHITE,
        //     :font=>Graphics.FONT_XTINY,
        //     :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
        //     :locY=>WatchUi.LAYOUT_VALIGN_CENTER + 50,
        // }).draw(dc);
        // new Text({
        //     :text=>testMetrics.bbOldestDateStr,
        //     :color=>Graphics.COLOR_GREEN,
        //     :font=>Graphics.FONT_XTINY,
        //     :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
        //     :locY=>WatchUi.LAYOUT_VALIGN_CENTER + 70,
        // }).draw(dc);
        // new Text({
        //     :text=>testMetrics.bbNew,
        //     :color=>Graphics.COLOR_WHITE,
        //     :font=>Graphics.FONT_XTINY,
        //     :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
        //     :locY=>WatchUi.LAYOUT_VALIGN_CENTER + 90,
        // }).draw(dc);
        // new Text({
        //     :text=>testMetrics.bbOld,
        //     :color=>Graphics.COLOR_GREEN,
        //     :font=>Graphics.FONT_XTINY,
        //     :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
        //     :locY=>WatchUi.LAYOUT_VALIGN_CENTER + 110,
        // }).draw(dc);



        // Time
        _timeLabel = createTimeLabel();
        updateTimeLabel(dc);

        // Date
        var dateLabel = drawDateString(dc);

        // Draw vertical line between time and date
        var lineY1 = _timeLabel.locY + _timeLabel.height;
        var lineY2 = dateLabel.locY;
        drawCenterLine(dc, lineY1, lineY2);

        // Draw hr
        var hrMetrics = _hrProvider.getMetrics();
        var hrViewX = 30;
        var hrViewY = lineY1;
        _hrView.draw(dc, hrMetrics.currentHr, hrViewX, hrViewY);

        // Draw high/low
        var highLowX = 20;
        var highLowY = lineY1 + _hrView.getHeight() + 7;
        _highLowHrView.draw(dc, highLowX, highLowY, hrMetrics.highHr, hrMetrics.lowHr);

        // Draw resting
        var restingX = 30;
        var restingY = highLowY + _highLowHrView.getHeight() + 7;
        _restingHrView.draw(dc, restingX, restingY, hrMetrics.restingHr, hrMetrics.avgRestingHr);

        // Draw bb
        var bbMetrics = _bbProvider.getMetrics(now);
        var bbX = 20;
        var bbY = restingY + _restingHrView.getHeight() + 10;
        _bbView.draw(dc, bbX, bbY, bbMetrics);

        // DEBUG
        // timeLabel.setBackgroundColor(Graphics.COLOR_RED);
        // dateLabel.setBackgroundColor(Graphics.COLOR_RED);

    }

    function updateTimeLabel(dc as Dc) as Void {
        // Get Info for a Moment in local time.
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM) as Gregorian.Info;
        var timeString = Lang.format("$1$:$2$", [today.hour.format("%02d"), today.min.format("%02d")]);
        _timeLabel.setText(timeString);
        _timeLabel.draw(dc);
    }


    function createTimeLabel() as Text {
        var font = Graphics.FONT_NUMBER_MILD;
        var color = Graphics.COLOR_WHITE;
        var timeLabel = new Text({
            :text=>"",
            :color=>color,
            :font=>font,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>0,
        });
        return timeLabel;
    }

    function drawDateString (dc as Dc) as Text {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        // Update date
        var dateString = Lang.format("$1$, $2$ $3$", [today.day_of_week, today.month, today.day]);
        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(dateString);
        return dateLabel;
    }

    function drawCenterLine(dc as Dc, startY as Number, endY as Number) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(self.centerX, startY, self.centerX, endY);
    }


    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
