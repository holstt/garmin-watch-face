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
        var timeString = Lang.format("$1$:$2$", [today.hour, today.min.format("%02d")]);
        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setText(timeString);

        // Update date
        var dateString = Lang.format("$1$, $2$ $3$", [today.day_of_week, today.month, today.day]);
        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(dateString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

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
