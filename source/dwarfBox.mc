import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DwarfBox extends WatchUi.Drawable {
    private var bgColor as Number, screenWidth as Number;
    private var icon as WatchUi.Bitmap, label as WatchUi.Text;
    private var shieldBar as IconGauge, healthBar as IconGauge;

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
            :locY=>locY + yStep/2,
            :font=>Graphics.FONT_XTINY,
            :color=>params[:color],
            :justification=>Graphics.TEXT_JUSTIFY_LEFT+Graphics.TEXT_JUSTIFY_VCENTER,
        });

        shieldBar = new IconGauge({
            :locX=>rightIconMargin,
            :locY=>locY + yStep,
            :width=>width,
            :color=>Properties.getValue("ShieldColor") as Number,
            :bg=>Properties.getValue("ShieldBgColor") as Number,
            :rezId=>Rez.Drawables.ShieldIcon,
        });

        healthBar = new IconGauge({
            :locX=>rightIconMargin,
            :locY=>locY + 2*yStep,
            :width=>width,
            :color=>Properties.getValue("HealthColor") as Number,
            :bg=>Properties.getValue("HealthBgColor") as Number,
            :rezId=>Rez.Drawables.HealthIcon,
        });
    }

    function setImage(image as Graphics.BitmapType or Lang.ResourceId or Null) {
        icon.setBitmap(image);
    }
    function setLabel(name as String) {
        label.setText(name);
    }

    function setShield(value as Float) {
        shieldBar.setProgress(value);
    }
    function setHealth(value as Float) {
        healthBar.setProgress(value);
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