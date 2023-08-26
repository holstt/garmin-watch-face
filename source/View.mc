import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class View extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
        System.println("Initialized");
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view.
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        // NB: Calls to dc before this will be overwritten!
        // Run own custom drawing code below...

        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        // var dateString = Lang.format(
        //     "$1$:$2$:$3$ $4$ $5$ $6$ $7$",
        //     [
        //         today.hour,
        //         today.min,
        //         today.sec,
        //         today.day_of_week,
        //         today.day,
        //         today.month,
        //         today.year
        //     ]
        // );
        // System.println(dateString); // e.g. "16:28:32 Wed 1 Mar 2017"

        // Update time
        var timeString = Lang.format("$1$:$2$", [today.hour.format("%02d"), today.min.format("%02d")]);
        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setText(timeString);


        // Update date
        var dateString = Lang.format("$1$, $2$ $3$", [today.day_of_week, today.month, today.day]);
        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(dateString);

        // DEBUG
        // timeLabel.setBackgroundColor(Graphics.COLOR_RED);
        // dateLabel.setBackgroundColor(Graphics.COLOR_RED);

        // System.println("Time: " + timeString);

        var fontHeight = dc.getFontHeight(Graphics.FONT_NUMBER_MILD);
        var fontDescent = Graphics.getFontDescent(Graphics.FONT_LARGE);
        // System.println(Lang.format("TimeLabel: $1$ $2$", [timeLabel.locX, timeLabel.locY]));
        // var startPos = timeLabel.locY + fontHeight + fontDescent/4;
        var lineY1 = timeLabel.locY + fontHeight + fontDescent / 4;


        fontHeight = dc.getFontHeight(Graphics.FONT_SMALL);
        fontDescent = Graphics.getFontDescent(Graphics.FONT_SMALL);
        // var lineY2 = dateLabel.locY + fontHeight;
        var lineY2 = dateLabel.locY + fontDescent / 4;


        // Draw vertical line between time and date
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var cx = dc.getWidth() / 2;
        dc.setPenWidth(2);
        dc.drawLine(cx, lineY1, cx, lineY2);

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
