import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class StatsBox extends WatchUi.Drawable {

    typedef StatsBoxParams as {
        :locX as Number,
        :locY as Number,
        :width as Number,
        :stepsRezId as Lang.ResourceId,
        :caloriesRezId as Lang.ResourceId,
        :color as Number,
        :backgroundColor as Number,
    };

    function initialize(params as StatsBoxParams) {
        Drawable.initialize(params);
    }

    function setSteps(steps as Number) {
        // TODO:
    }
    function setCalories(calories as Number) {
        // TODO:
    }

    function draw(dc) {
    }
}