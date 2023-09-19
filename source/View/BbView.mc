import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
using Toybox.Time;
import Toybox.SensorHistory;



class BbView {

    hidden var _icon as BitmapResource;

    function initialize(icon as BitmapResource) {
        _icon = icon;
    }

    function getHeight() as Number {
        return _icon.getHeight();
    }

    // XXX: Simple draw for now
    function draw(dc as Dc, aX as Number, aY as Number, metrics as BodyBatteryMetrics) as Void {
       dc.drawBitmap(aX, aY, _icon);

       var todayX = aX + _icon.getWidth() + 10;
       var today = drawToday(dc, todayX, aY, metrics);

       var yesterdayX = aX;
       var yesterdayY = aY + today.height;
       drawHistory(dc, yesterdayX, yesterdayY, metrics);
    }

    hidden function drawToday(dc as Dc, aX as Number, aY as Number, metrics as BodyBatteryMetrics) {
        var font = Graphics.FONT_SYSTEM_TINY;
        var color = Graphics.COLOR_WHITE;

        var textHeight = dc.getFontHeight(font);
        var textX = aX;
        var textY = aY + (_icon.getHeight() - textHeight) / 2;

        var textView = new Text({
            :text=>Lang.format("$1$/$2$", [getData(metrics.current), getData(metrics.todayMax)]),
            :color=>color,
            :font=>font,
            :locX=>textX,
            :locY=>textY
        });
        textView.draw(dc);
        return textView;
    }

    hidden function drawHistory(dc as Dc, aX as Number, aY as Number, metrics as BodyBatteryMetrics) {
        var font = Graphics.FONT_SYSTEM_TINY;
        var color = Graphics.COLOR_WHITE;

        var textX = aX;
        var textY = aY;

        var textView = new Text({
            :text=>Lang.format("$1$/$2$ ($3$)", [getData(metrics.yesterdayMin), getData(metrics.yesterdayMax), toViewNumber(metrics.avgMax)]),
            :color=>color,
            :font=>font,
            :locX=>textX,
            :locY=>textY
        });
        textView.draw(dc);
        return textView;
    }

    hidden function getData(sample as SensorSample or Null) as String{
        return sample != null ? toViewNumber(sample.data) : toViewNumber(sample);
    }
}