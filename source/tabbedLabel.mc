import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TabbedLabel extends WatchUi.Text {
    const TAB_SLICE_SIZE as Number = 15;

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
        :font as Graphics.FontType,
    };

    function initialize(params as TabbedLabelParams) {
        // Add padding to initial text, if any
        if (params.hasKey(:text)) {
            params[:text] = " " + params[:text] + " ";
        }
        Text.initialize(params);

        if (params.hasKey(:tabBackgroundColor)) {
            tabBgColor = params[:tabBackgroundColor];
        } else {
            tabBgColor = Graphics.COLOR_BLACK;
        }
        tabLabel = new WatchUi.Text({
            :text=>params[:label],
            :color=>params[:tabColor],
            :bgColor=>params[:tabBackgroundColor],
            :locX=>locX + 2,
            :locY=>locY - 20,
            :font=>Graphics.FONT_XTINY,
        });
    }

    function setText(text) {
        // Padding looks way better
        Text.setText(" " + text + " ");
    }
    function setLabel(text as String or ResourceId) {
        tabLabel.setText(text);
    }

    function draw(dc) {
        // Draw main text first, since it comes with a background
        Text.draw(dc);

        // Calculate tab bar vertex positions
        width = dc.getTextWidthInPixels(mText, mFont);  // Does this not happen automatically during draw?
        var tabUpperEdge = locY - tabLabel.height + 4;
        var tabRightEdge = tabLabel.locX + tabLabel.width;
        var upperEdge = tabUpperEdge + TAB_SLICE_SIZE;
        var rightEdge = locX + width - 1;  // Not sure why, but the right edge is always off by one pixel

        // Draw decorations over background
        dc.setColor(tabBgColor, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([
            [locX, locY],
            [locX, tabUpperEdge],
            [tabRightEdge, tabUpperEdge],
            [tabRightEdge + TAB_SLICE_SIZE, upperEdge],
            [rightEdge, upperEdge],
            [rightEdge, locY],
        ]);
        // And the actual tab label
        tabLabel.draw(dc);
    }
}