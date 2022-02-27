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
   var fontNumberSmall = null;
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

      fontNumberMed = Ui.loadResource(Rez.Fonts.robobk55numbers);
      fontNumberSmall = Ui.loadResource(Rez.Fonts.robobk48numbers);

      yRow0Label = 20;   // zone area
      yTopLine = 40;     // ----------
      yRow1Label = 58;   // timer/BPM label
      yRow1Number = 99;  // timer/BPM value
      yMiddleLine = 140; // ----------
      yRow2Number = 177; // dist/pace value
      yRow2Label = 213;  // dist/pace label
      yBottomLine = 229; // ----------
      yRow3Label = 250;  // time

      xTopLine = 160;
      xBottomLine = 142;

      xRow0Label = 141;
      xRow1Col1Label = 95;
      xRow1Col1Num = 85;
      xRow1Col2Label = 200;
      xRow1Col2Num = 211;
      xRow2Col1Label = 80;
      xRow2Col1Num = 79;
      xRow2Col2Label = 194;
      xRow2Col2Num = 207;
      xRow3Label = 146;
   }

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration < 3600) {
         return fontNumberMed;
      } else {
//         return Gfx.FONT_NUMBER_MILD;
         return fontNumberSmall;
      }
   }

   /*
    * Gets the heartRate font.
    */
   function getHeartRateFont(heartRate)
   {
      return fontNumberMed;
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      return fontNumberMed;
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      return fontNumberMed;
   }

   /*
    * Gets the time-of-day font.
    */
   function getTimeOfDayFont()
   {
      return Gfx.FONT_MEDIUM;
   }
}
