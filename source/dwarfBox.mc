import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DwarfBox extends WatchUi.Drawable {
    private var bgColor as Number, screenWidth as Number;
    private var icon as WatchUi.Bitmap, label as WatchUi.Text;
    private var shieldBar as WatchUi.Drawable, healthBar as WatchUi.Drawable;

    typedef DwarfBoxParams as {
        :locX as Number,
        :locY as Number,
        :width as Number,
        :rezId as Lang.ResourceId,
        :color as Number,
        :backgroundColor as Number,
    };

    function initialize(params as DwarfBoxParams) {
        Drawable.initialize(params);

        bgColor = params[:backgroundColor] as Number;
        screenWidth = System.getDeviceSettings().screenWidth;

        icon = new WatchUi.Bitmap({
            :rezId=>params[:rezId],
            :locX=>locX,
            :locY=>locY,
        });
        var rightIconMargin = locX + icon.width;
        var yStep = icon.height / 3;

        label = new WatchUi.Text({
            :text=>"KARL",
            :locX=>rightIconMargin,
            :locY=>locY - 5,
            :font=>Graphics.FONT_XTINY,
            :color=>params[:color],
            :justification=>Graphics.TEXT_JUSTIFY_LEFT,
        });

        shieldBar = new WatchUi.Text({
            :text=>"SHIELD TODO",
            :locX=>rightIconMargin,
            :locY=>locY + yStep,
            :font=>Graphics.FONT_XTINY,
        });

        healthBar = new IconGauge({
            :text=>"HEALTH TODO",
            :locX=>rightIconMargin,
            :locY=>locY + 2*yStep,
            :font=>Graphics.FONT_XTINY,
        });
    }

    function setImage(image as WatchUi.BitmapResource or Graphics.BitmapReference) {
        icon.setBitmap(image);
    }
    function setLabel(name as String) {
        label.setText(name);
    }

    function setShield(value as Float) {
        // TODO:
    }
    function setHealth(value as Float) {
        // TODO:
    }

    function draw(dc) {
        dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, locY - 3, screenWidth, icon.height + 6);
        icon.draw(dc);
        label.draw(dc);
        shieldBar.draw(dc);
        healthBar.draw(dc);
    }
}