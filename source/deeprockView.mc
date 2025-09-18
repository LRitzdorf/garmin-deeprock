import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class deeprockView extends WatchUi.WatchFace {

    private var backgroundImg as Graphics.BitmapType?;
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
        backgroundImg = WatchUi.loadResource(Rez.Drawables.Background);
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
            if (getProp("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
            }
        }
        timeFormat += " HXT";
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

        dc.drawBitmap(0, 0, backgroundImg);
        // Manually draw the layout
        for (var i = 0; i < mLayout.size(); i++) {
            mLayout[i].draw(dc);
        }
    }

    function onSettingsChanged() as Void {
        var image_and_name = getClassData();
        dwarfBox.setImage(image_and_name[0]);
        dwarfBox.setLabel(image_and_name[1].toUpper());
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        backgroundImg = null;
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    // Dwarf images, where index corresponds to class_number + (simplified_icon * 0b100)
    const DwarfImages = [
        Rez.Drawables.Driller_portrait,
        Rez.Drawables.Engineer_portrait,
        Rez.Drawables.Gunner_portrait,
        Rez.Drawables.Scout_portrait,
        Rez.Drawables.Driller_icon,
        Rez.Drawables.Engineer_icon,
        Rez.Drawables.Gunner_icon,
        Rez.Drawables.Scout_icon,
    ];
    // Dwarf names, where index corresponds to class_number
    const DwarfStrings = [
        Rez.Strings.DwarfClassDriller,
        Rez.Strings.DwarfClassEngineer,
        Rez.Strings.DwarfClassGunner,
        Rez.Strings.DwarfClassScout,
    ];

    // Select the appropriate class image and name.
    function getClassData() as [Lang.ResourceId, String] {
        // Compute class name and image resource indices
        var nameIdx = getProp("DwarfClass") as Number;
        var imageIdx = nameIdx + (getProp("UseClassIcon") as Boolean ? 4 : 0);

        // Select relevant resources
        var image = DwarfImages[imageIdx];
        var name = DwarfStrings[nameIdx];

        // Handle custom name, if any
        var customName = getProp("CustomDwarfName") as String;
        if (customName.length() > 0) {
            name = customName;
        } else {
            name = WatchUi.loadResource(name);
        }

        return [image, name];
    }

}
