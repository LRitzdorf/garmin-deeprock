import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class deeprockView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
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

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Format character status area
        var className;
        switch (Application.Properties.getValue("DwarfClass")) {
            default:
            case 0:
                className = "DRILLER";
                break;
            case 1:
                className = "ENGINEER";
                break;
            case 2:
                className = "GUNNER";
                break;
            case 3:
                className = "SCOUT";
                break;
        }
        var classString = Lang.format(
            "$1$, icon: $2$",
            [className, Application.Properties.getValue("UseClassIcon")]
        );

        // Get the current date/time
        var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var hours = now.hour;

        // Format time
        var timeFormat = "$1$:$2$";
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.Properties.getValue("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
            }
        }
        if (Application.Properties.getValue("HoxxesTimeSuffix") as Boolean) {
            timeFormat += " HXT";
        }
        var timeString = Lang.format(
            timeFormat,
            [hours.format("%02d"), now.min.format("%02d")]
        );

        // Format date
        var dateString = Lang.format(
            "$1$ $2$ $3$ $4$",
            [now.day_of_week.toUpper(), now.day, now.month.toUpper(), now.year]
        );

        // Update the view
        (View.findDrawableById("ClassLabel") as Text).setText(classString);
        (View.findDrawableById("TimeLabel") as Text).setText(timeString);
        (View.findDrawableById("DateLabel") as Text).setText(dateString);

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
