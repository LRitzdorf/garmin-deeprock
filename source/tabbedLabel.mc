import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TabbedLabel extends WatchUi.Text {
    private var tabBgColor as Number;
    private var tabLabel as WatchUi.Text;

    typedef TabbedLabelParams as {
        :locX as Number,
        :locY as Number,
        :text as String,
        :color as Number,
        :backgroundColor as Number,
        :label as String,
        :tabColor as Number,
        :tabBackgroundColor as Number,
    };

    function initialize(params as TabbedLabelParams) {
        Text.initialize(params);
        if (params.hasKey(:tabBackgroundColor)) {
            tabBgColor = params[:tabBackgroundColor];
        } else {
            tabBgColor = Graphics.COLOR_BLACK;
        }
        tabLabel = new WatchUi.Text({
            :text=>params[:label],
            :color=>params[:tabColor],
            // TODO: Positioning
        });
    }

    function setLabel(text as String or ResourceId) {
        tabLabel.setText(text);
    }

    function draw(dc) {
        // TODO: Draw background and tab bar
        tabLabel.draw(dc);
        Text.draw(dc);
    }
}