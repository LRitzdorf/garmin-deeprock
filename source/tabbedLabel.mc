import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TabbedLabel extends WatchUi.Text {
    private var tabBgColor as Number, tabThinWidth as Number;
    private var tabLabel as WatchUi.Text;
    private var tabText as String, tabFont as Graphics.FontType;

    typedef TabbedLabelParams as {
        :locX as Number,
        :locY as Number,
        :text as String,
        :color as Number,
        :backgroundColor as Number,
        :label as String,
        :labelYOffset as Number,
        :tabColor as Number,
        :tabBackgroundColor as Number,
        :tabThinStrip as Number,
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
        tabThinWidth = params[:tabThinStrip];
        tabLabel = new WatchUi.Text({
            :text=>params[:label],
            :color=>params[:tabColor],
            :bgColor=>params[:tabBackgroundColor],
            :locX=>locX + tabThinWidth,
            :locY=>locY - params[:labelYOffset],
            :font=>Graphics.FONT_XTINY,
            :justification=>Graphics.TEXT_JUSTIFY_LEFT+Graphics.TEXT_JUSTIFY_VCENTER,
        });
        tabText = params[:label];
        tabFont = Graphics.FONT_XTINY;
    }

    function setText(text) {
        // Padding looks way better
        Text.setText(" " + text + " ");
    }
    function setLabel(text as String) {
        tabLabel.setText(text);
        tabText = text;
    }

    function draw(dc) {
        // Draw main text first, since it comes with a background
        Text.draw(dc);

        // Calculate tab bar vertex positions
        width = dc.getTextWidthInPixels(mText, mFont);  // Does this not happen automatically during draw?
        var upperEdge = locY - tabThinWidth;
        var rightEdge = locX + width - 1;  // Off-by-one
        var tabDims = dc.getTextDimensions(tabText, tabFont);
        var tabUpperEdge = tabLabel.locY - tabDims[1]/2.5;  // Calculated height looks excessive
        var tabRightEdge = tabLabel.locX + tabDims[0];

        // Draw decorations over background
        dc.setColor(tabBgColor, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([
            [locX, locY],
            [locX, tabUpperEdge],
            [tabRightEdge, tabUpperEdge],
            [tabRightEdge + (upperEdge - tabUpperEdge) + 1, upperEdge],  // Off-by-one
            [rightEdge, upperEdge],
            [rightEdge, locY],
        ]);
        // And the actual tab label
        tabLabel.draw(dc);
    }
}