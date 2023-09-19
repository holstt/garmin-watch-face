import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
using Toybox.Time;


class ResLoader {
    var iconHr = Application.loadResource(Rez.Drawables.hr) as BitmapResource;
    var iconUp = Application.loadResource(Rez.Drawables.up) as BitmapResource;
    var iconDown = Application.loadResource(Rez.Drawables.down) as BitmapResource;
    var iconBb = Application.loadResource(Rez.Drawables.bb) as BitmapResource;
}