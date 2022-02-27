using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Attention as Attn;
using Toybox.UserProfile as Profile;

/*
 * DeviceField
 */
class DeviceField extends RunZoneField
{
   var fontNumberMed = null;
   var fontNumberHot = null;
   /*
    * Constructor.
    */
   function initialize()
   {
      RunZoneField.initialize();
   }

   /*
    * Sets the layout.
    */
   function onLayout(dc)
   {
      RunZoneField.onLayout(dc);

      fontNumberMed = Ui.loadResource(Rez.Fonts.robobk76numbers);
      fontNumberHot = Ui.loadResource(Rez.Fonts.robobk84numbers);

      yRow0Label = 35;   // zone area
      yTopLine = 70;     // ----------
      yRow1Label = 90;   // timer/BPM label
      yRow1Number = 150; // timer/BPM value
      yMiddleLine = 212; // ----------
      yRow2Number = 270; // dist/pace value
      yRow2Label = 327;  // dist/pace label
      yBottomLine = 343; // ----------
      yRow3Label = 374;  // time

      xTopLine = 240;
      xBottomLine = 213;

      xRow0Label = 206;      // zone
      xRow1Col1Label = 138;  // timer label
      xRow1Col1Num = 128;    // timer value
      xRow1Col2Label = 290;  // BPM label
      xRow1Col2Num = 312;    // BPM value
      xRow2Col1Label = 120;  // dist label
      xRow2Col1Num = 120;    // dist value
      xRow2Col2Label = 288;  // pace label
      xRow2Col2Num = 301;    // pace value
      xRow3Label = 210;      // time
   }

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration < 3600) {
         return fontNumberHot;
      } else {
         return fontNumberMed;
      }
//      return fontNumberHot;
   }

   /*
    * Gets the heartRate font.
    */
   function getHeartRateFont(heartRate)
   {
      return fontNumberHot;
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      return fontNumberHot;
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      return fontNumberHot;
   }

   /*
    * Gets the time-of-day font.
    */
   function getTimeOfDayFont()
   {
      return Gfx.FONT_MEDIUM;
   }
}
