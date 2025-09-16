import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class deeprockGoalView extends WatchUi.View {

    private var goalType as Application.GoalType;
    private var splashImg as Graphics.BitmapType?;
    private var messageBox as Text?;

    function initialize() {
        View.initialize();
        goalType = Application.GOAL_TYPE_STEPS;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.GoalScreen(dc));
        messageBox = View.findDrawableById("Message") as Text;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        // Load splash image
        splashImg = WatchUi.loadResource(Rez.Drawables.Pickaxe);

        // Load relevant goal text
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
        messageBox.setText(WatchUi.loadResource(goalName));
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Fill with black, then draw splash image
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.drawBitmap((dc.getWidth()-splashImg.getWidth())/2, 10, splashImg);

        // Manually draw the layout
        for (var i = 0; i < mLayout.size(); i++) {
            mLayout[i].draw(dc);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        splashImg = null;
        messageBox.setText("");
    }

    // Set the goal type for use while drawing
    function setGoalType(type as Application.GoalType) as Void {
        goalType = type;
    }

}
