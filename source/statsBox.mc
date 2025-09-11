import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class StatsBox extends WatchUi.Drawable {
    private var bgColor as Number, screenWidth as Number;
    private var stepsIcon as WatchUi.Bitmap, stepsLabel as WatchUi.Text;
    private var caloriesIcon as WatchUi.Bitmap, caloriesLabel as WatchUi.Text;

    typedef StatsBoxParams as {
        :locY as Number,
        :width as Number,
        :height as Number,
        :stepsRezId as Lang.ResourceId,
        :caloriesRezId as Lang.ResourceId,
        :color as Number,
        :backgroundColor as Number,
        :font as Graphics.FontType,
    };

    function initialize(params as StatsBoxParams) {
        Drawable.initialize(params);

        bgColor = params[:backgroundColor] as Number;
        screenWidth = System.getDeviceSettings().screenWidth;

        stepsIcon = new WatchUi.Bitmap({
            :rezId=>params[:stepsRezId],
            :locX=>screenWidth/2 - width/2,
            :locY=>locY,
        });
        stepsLabel = new WatchUi.Text({
            :text=>"1337",
            :locX=>stepsIcon.locX + stepsIcon.width,
            :locY=>locY + stepsIcon.height/2,
            :font=>params[:font],
            :color=>params[:color],
            :justification=>Graphics.TEXT_JUSTIFY_LEFT+Graphics.TEXT_JUSTIFY_VCENTER,
        });

        caloriesIcon = new WatchUi.Bitmap({
            :rezId=>params[:caloriesRezId],
            :locX=>screenWidth/2,
            :locY=>locY,
        });
        caloriesLabel = new WatchUi.Text({
            :text=>"1337",
            :locX=>caloriesIcon.locX + caloriesIcon.width,
            :locY=>locY + caloriesIcon.height/2,
            :font=>params[:font],
            :color=>params[:color],
            :justification=>Graphics.TEXT_JUSTIFY_LEFT+Graphics.TEXT_JUSTIFY_VCENTER,
        });
    }

    function setSteps(steps as Number) {
        stepsLabel.setText(steps.toString());
    }
    function setCalories(calories as Number) {
        caloriesLabel.setText(calories.toString());
    }

    function draw(dc) {
        dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, locY - 3, screenWidth, stepsIcon.height + 6);
        stepsIcon.draw(dc);
        caloriesIcon.draw(dc);
        stepsLabel.draw(dc);
        caloriesLabel.draw(dc);
    }
}