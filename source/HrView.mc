import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
using Toybox.Time;

class CurrentHrView {
    // hidden var _aX;
    // hidden var _aY;
    hidden var _icon as BitmapResource;

    function initialize(icon as BitmapResource) {
        _icon = icon;
    }

    function getHeight() as Number {
        return _icon.getHeight();
    }

    function update(dc as Dc, currentHr as Number, aX as Number, aY as Number) as Void {
        // _aX = aX;
        // _aY = aY;

       dc.drawBitmap(aX, aY, _icon);
       draw(dc, aX + _icon.getWidth(), aY, toViewNumber(currentHr));
    }


    hidden function draw(dc as Dc, aX as Number, aY as Number, text as String) as Text {
        var font = Graphics.FONT_SYSTEM_TINY;
        var color = Graphics.COLOR_WHITE;

        var textHeight = dc.getFontHeight(font);
        var padX = 10;
        var textX = aX + padX;
        var textY = aY + (_icon.getHeight() - textHeight) / 2;

        var textView = new Text({
            :text=>text,
            :color=>color,
            :font=>font,
            :locX=>textX,
            :locY=>textY
        });
        textView.draw(dc);
        return textView;
    }
}


class HighLowHrView {
    hidden var _iconUp as BitmapResource;
    hidden var _iconDown as BitmapResource;

    function initialize(iconUp as BitmapResource, iconDown as BitmapResource) {
        _iconUp = iconUp;
        _iconDown = iconDown;
    }

    function getHeight() as Number {
        return _iconUp.getHeight();
    }

    function update(dc as Dc, aX as Number, aY as Number, hrHigh as Number, hrLow as Number) as Void {

        var newX = draw(dc, aX, aY, toViewNumber(hrHigh), _iconUp);
        draw(dc, aX + newX, aY, toViewNumber(hrLow), _iconDown);
    }

    hidden function draw( dc as Dc, aX as Number, aY as Number, text as String, icon as BitmapResource) as Number {
        // Icon
        dc.drawBitmap(aX, aY, icon);

        // Text
        var font = Graphics.FONT_SYSTEM_XTINY; // XXX: Number font?
        var color = Graphics.COLOR_WHITE;
        var textX = aX + icon.getWidth() + 5;

        // Center relative to icon
        var textHeight = dc.getFontHeight(Graphics.FONT_SYSTEM_XTINY);
        var textY = aY + (icon.getHeight() - textHeight) / 2;

        var textView = new Text({
            :text=>text,
            :color=>color,
            :font=>font,
            :locX=>textX,
            :locY=>textY
        });
        textView.draw(dc);
        return textX + textView.width;
    }

}



class RestingHrView {
    function initialize() {
    }

    public function draw(dc as Dc, aX as Number, aY as Number, restingHr as Number, restingHr7d as Number) {
        var font = Graphics.FONT_SYSTEM_XTINY;
        var color = Graphics.COLOR_WHITE;

        var textView = new Text({
            :text=>Lang.format("R $1$ ($2$)", [toViewNumber(restingHr), toViewNumber(restingHr7d)]),
            :color=>color,
            :font=>font,
            :locX=>aX,
            :locY=>aY
        });
        textView.draw(dc);
    }

}
