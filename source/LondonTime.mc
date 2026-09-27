import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// Works out London's current UTC offset (GMT in winter, BST in summer).
// UK rule: BST runs from 01:00 UTC on the last Sunday of March
// until 01:00 UTC on the last Sunday of October.
module LondonTime {

    var _cachedYear as Number = -1;
    var _bstStart as Number = 0;
    var _bstEnd as Number = 0;

    // Epoch seconds of 01:00 UTC on the last Sunday of the given month.
    function lastSundayAt1amUtc(year as Number, month as Number) as Number {
        var m = Gregorian.moment({:year => year, :month => month, :day => 31,
                                  :hour => 1, :minute => 0, :second => 0});
        var info = Gregorian.utcInfo(m, Time.FORMAT_SHORT);
        // day_of_week: 1 = Sunday ... 7 = Saturday
        var back = (info.day_of_week as Number) - 1;
        return m.value() - back * Gregorian.SECONDS_PER_DAY;
    }

    function offsetSeconds(now as Time.Moment) as Number {
        var year = Gregorian.utcInfo(now, Time.FORMAT_SHORT).year as Number;
        if (year != _cachedYear) {
            _bstStart = lastSundayAt1amUtc(year, 3);
            _bstEnd = lastSundayAt1amUtc(year, 10);
            _cachedYear = year;
        }
        var t = now.value();
        return (t >= _bstStart && t < _bstEnd) ? 3600 : 0;
    }

    // Calendar info for London "now".
    function info(now as Time.Moment) as Gregorian.Info {
        var london = now.add(new Time.Duration(offsetSeconds(now)));
        return Gregorian.utcInfo(london, Time.FORMAT_SHORT);
    }
}
