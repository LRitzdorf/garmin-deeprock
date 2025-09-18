import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class deeprockApp extends Application.AppBase {

    private var faceView as deeprockView?;
    private var goalView as deeprockGoalView?;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        if (faceView == null) {
            faceView = new deeprockView();
        }
        return [ faceView ];
    }

    // Return the goal view of your application here, or null to fall back to system
    function getGoalView(goalType as GoalType) as [View] or Null {
        if (!(getProp("UseCustomGoalScreen") as Boolean)) {
            return null;
        }
        if (goalView == null) {
            goalView = new deeprockGoalView();
        }
        goalView.setGoalType(goalType);
        return [ goalView ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        faceView.onSettingsChanged();
        WatchUi.requestUpdate();
    }

}

function getApp() as deeprockApp {
    return Application.getApp() as deeprockApp;
}


// Retrieve settings based on the device's API version

(:pre240)
function getProp(key as String) as Application.PropertyValueType {
    return (deeprockApp as AppBase).getProperty(key);
}

(:post240)
function getProp(key as String) as Application.PropertyValueType {
    return Application.Properties.getValue(key);
}