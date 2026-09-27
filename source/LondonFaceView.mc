import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class LondonFaceView extends WatchUi.WatchFace {

    private var _background as WatchUi.BitmapResource?;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        _background = WatchUi.loadResource(Rez.Drawables.Background) as WatchUi.BitmapResource;
    }

    function onUpdate(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;

        // Background image (centered)
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        var bg = _background;
        if (bg != null) {
            dc.drawBitmap((w - bg.getWidth()) / 2, (h - bg.getHeight()) / 2, bg);
        }

        var is24 = System.getDeviceSettings().is24Hour;
        var now = Time.now();

        // Local time: the watch's own clock, which Garmin Connect / the phone keeps in sync.
        var local = Gregorian.info(now, Time.FORMAT_SHORT);
        drawText(dc, cx, h * 0.42, Graphics.FONT_NUMBER_THAI_HOT,
                 formatTime(local.hour, local.min, is24, false));

        // Date: MM/DD/YYYY
        var date = Lang.format("$1$/$2$/$3$", [
            (local.month as Number).format("%02d"),
            local.day.format("%02d"),
            local.year
        ]);
        drawText(dc, cx, h * 0.20, Graphics.FONT_SMALL, date);

        // London time
        var ldn = LondonTime.info(now);
        drawText(dc, cx, h * 0.67, Graphics.FONT_MEDIUM,
                 "LONDON " + formatTime(ldn.hour, ldn.min, is24, true));

        // Battery percentage
        var battery = System.getSystemStats().battery;
        drawText(dc, cx, h * 0.84, Graphics.FONT_SMALL, battery.format("%d") + "%");
    }

    private function formatTime(hour as Number, min as Number, is24 as Boolean, showAmPm as Boolean) as String {
        var suffix = "";
        if (!is24) {
            suffix = hour < 12 ? " AM" : " PM";
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }
        var text = hour.format(is24 ? "%02d" : "%d") + ":" + min.format("%02d");
        return showAmPm ? text + suffix : text;
    }

    // White text with a black shadow so it stays readable on any picture.
    private function drawText(dc as Dc, x as Number, y as Numeric, font as Graphics.FontType, text as String) as Void {
        var just = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
        var yi = y.toNumber();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 2, yi + 2, font, text, just);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, yi, font, text, just);
    }
}
