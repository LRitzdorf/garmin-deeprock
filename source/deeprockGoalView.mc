import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class deeprockGoalView extends WatchUi.View {

    private var goalType as Application.GoalType;
    private var splashImg as Bitmap?;

    function initialize() {
        View.initialize();
        goalType = Application.GOAL_TYPE_STEPS;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.GoalScreen(dc));
        splashImg = View.findDrawableById("Splash") as Bitmap;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        splashImg.setBitmap(Rez.Drawables.Pickaxe);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Load the relevant goal text
        var goalName;
        switch (goalType) {
            default:
            case Application.GOAL_TYPE_STEPS:
                goalName = Rez.Strings.GoalTypeSteps;
                break;
            case Application.GOAL_TYPE_FLOORS_CLIMBED:
                goalName = Rez.Strings.GoalTypeFloors;
                break;
            case Application.GOAL_TYPE_ACTIVE_MINUTES:
                goalName = Rez.Strings.GoalTypeActivity;
                break;
        }

        // Set the goal message
        var messageBox = View.findDrawableById("Message") as TextArea;
        messageBox.setText(Lang.format("ROCK AND STONE!\nYou hit your $1$ goal", [goalName]));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        splashImg.setBitmap(null);
    }

    // Set the goal type for use while drawing
    function setGoalType(type as Application.GoalType) as Void {
        goalType = type;
    }

}
