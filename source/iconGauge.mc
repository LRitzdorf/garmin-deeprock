import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class IconGauge extends WatchUi.Drawable {
    private var fillColor as Number, bgColor as Number, fillWidth as Number;
    private var icon;

    typedef IconGaugeParams as {
        :locX as Number,
        :locY as Number,
        :width as Number,
        :color as Number,
        :bg as Number,
        :rezId as Lang.ResourceId,
    };

    function initialize(params as IconGaugeParams) {
        Drawable.initialize(params);
        fillColor = params[:color];
        bgColor = params[:bg];
        // Load icon
        icon = new WatchUi.Bitmap({
            :rezId=>params[:rezId],
            :locX=>locX,
            :locY=>locY,
        });
        // Offset bar to avoid covering icon
        width = params[:width] - icon.width;
        locX += icon.width;
        // Automatically match icon height
        height = icon.height;
        // Don't crash on first draw
        fillWidth = 0;
    }

    function setProgress(progress as Float) {
        if (progress > 1.0) {
            progress = 1.0;
        }
        fillWidth = (progress * width).toNumber();
    }

    function draw(dc) {
        icon.draw(dc);
        dc.setColor(fillColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(locX, locY, fillWidth, height);
        dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(locX+fillWidth, locY, width-fillWidth, height);
    }
}