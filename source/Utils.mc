import Toybox.Lang;
import Toybox.Time;


function toViewNumber(value as Number or Null) as String {
    if (value == null or value == 0) {
        return "-";
    } else {
        return value.format("%d").toString();
    }
}


function toDurationString(duration as Duration) as String {
    // Use moment to be able to format the duration. Create a fake date with the duration as the time.
    var fakeDate = new Moment(duration.value()); // Assumes UTC, so create gregorian info as UTC (i.e. no conversion will be done)
    var durationInfo = Gregorian.utcInfo(fakeDate, Time.FORMAT_MEDIUM) as Gregorian.Info;
    return Lang.format(
    "$1$:$2$:$3$",
    [
        durationInfo.hour.format("%02d"),
        durationInfo.min.format("%02d"),
        durationInfo.sec.format("%02d")
    ]
);
}

function toTimeStringFromInfo(timeInfo as Gregorian.Info) as String {
    return Lang.format(
        "$1$:$2$:$3$ $4$ $5$ $6$ $7$",
        [
            timeInfo.hour.format("%02d"),
            timeInfo.min.format("%02d"),
            timeInfo.sec.format("%02d"),
            timeInfo.day_of_week,
            timeInfo.day,
            timeInfo.month,
            timeInfo.year
        ]
    );
}


function toTimeString(time as Moment) as String {
    var timeInfo = Gregorian.utcInfo(time, Time.FORMAT_MEDIUM) as Gregorian.Info;
    return toTimeStringFromInfo(timeInfo);
}



function printDuration(duration as Duration) as Void {
    log(toDurationString(duration));
}

function printTime(time as Moment) as Void {
    log(toTimeString(time));
}