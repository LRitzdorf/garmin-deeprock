import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class deeprockView extends WatchUi.WatchFace {

    private var dwarfBox as DwarfBox?;
    private var timeLabel as TabbedLabel?, dateLabel as TabbedLabel?;
    private var statsBox as StatsBox?;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        dwarfBox = View.findDrawableById("DwarfBox") as DwarfBox;
        timeLabel = View.findDrawableById("TimeLabel") as TabbedLabel;
        dateLabel = View.findDrawableById("DateLabel") as TabbedLabel;
        statsBox = View.findDrawableById("StatsBox") as StatsBox;
        onSettingsChanged();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
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

        // Get status and activity data
        var battery = System.getSystemStats().battery;
        var activity = ActivityMonitor.getInfo();
        var steps = activity.steps == null ? 0 : activity.steps;
        var calories = activity.calories == null ? 0 : activity.calories;
        var stepProgress = activity.stepGoal == null ? 0.0 : (steps.toFloat() / activity.stepGoal);

        // Update the view
        dwarfBox.setShield(battery/100);
        dwarfBox.setHealth(stepProgress);
        timeLabel.setText(timeString);
        dateLabel.setText(dateString);
        statsBox.setSteps(steps);
        statsBox.setCalories(calories);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function onSettingsChanged() as Void {
        var image_and_name = loadClassData();
        dwarfBox.setImage(image_and_name[0]);
        dwarfBox.setLabel(image_and_name[1].toUpper());
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

    // Load a class image and string into memory.
    function loadClassData() as [WatchUi.BitmapResource or Graphics.BitmapReference, String] {
        var image, name;
        var useIcon = Application.Properties.getValue("UseClassIcon") as Boolean;

        // Identify class and select appropriate image resource
        switch (Application.Properties.getValue("DwarfClass") as Integer) {
            default:
            case 0: // DRILLER
                name = Rez.Strings.DwarfClassDriller;
                if (useIcon) {
                    image = Rez.Drawables.Driller_icon;
                } else {
                    image = Rez.Drawables.Driller_portrait;
                }
                break;
            case 1: // ENGINEER
                name = Rez.Strings.DwarfClassEngineer;
                if (useIcon) {
                    image = Rez.Drawables.Engineer_icon;
                } else {
                    image = Rez.Drawables.Engineer_portrait;
                }
                break;
            case 2: // GUNNER
                name = Rez.Strings.DwarfClassGunner;
                if (useIcon) {
                    image = Rez.Drawables.Gunner_icon;
                } else {
                    image = Rez.Drawables.Gunner_portrait;
                }
                break;
            case 3: // SCOUT
                name = Rez.Strings.DwarfClassScout;
                if (useIcon) {
                    image = Rez.Drawables.Scout_icon;
                } else {
                    image = Rez.Drawables.Scout_portrait;
                }
                break;
        }
        image = WatchUi.loadResource(image);

        // Handle custom name, if any
        var customName = Application.Properties.getValue("CustomDwarfName") as String;
        if (customName.length() > 0) {
            name = customName;
        } else {
            name = WatchUi.loadResource(name);
        }

        return [image, name];
    }

}
