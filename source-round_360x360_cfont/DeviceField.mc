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

      fontNumberHot = Ui.loadResource(Rez.Fonts.robobk68numbers);

      yRow0Label = 34;   // zone area
      yTopLine = 65;     // ----------
      yRow1Label = 81;   // timer/BPM label
      yRow1Number = 136;  // timer/BPM value
      yMiddleLine = 180; // ----------
      yRow2Number = 231; // dist/pace value
      yRow2Label = 280;  // dist/pace label
      yBottomLine = 295; // ----------
      yRow3Label = 325;  // time

      xTopLine = 216;
      xBottomLine = 185;

      xRow0Label = 176;      // zone
      xRow1Col1Label = 112;  // timer lbl
      xRow1Col1Num = 112;    // timer val
      xRow1Col2Label = 274;  // hr lbl
      xRow1Col2Num = 278;    // hr val
      xRow2Col1Label = 116;  // dist lbl
      xRow2Col1Num = 105;    // dist val
      xRow2Col2Label = 262;  // pace lbl
      xRow2Col2Num = 262;    // pace val
      xRow3Label = 178;      // time
   }

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
//      if (duration < 3600) {
//         return fontNumberHot;
//      } else {
//         return Gfx.FONT_NUMBER_MEDIUM;
//      }
         return fontNumberHot;
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
