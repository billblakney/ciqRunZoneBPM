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

      fontNumberHot = Ui.loadResource(Rez.Fonts.robobk76numbers);

      yRow0Label = 34;   // zone area
      yTopLine = 62;     // ----------
      yRow1Label = 82;   // timer/BPM label
      yRow1Number = 145;  // timer/BPM value
      yMiddleLine = 195; // ----------
      yRow2Number = 245; // dist/pace value
      yRow2Label = 300;  // dist/pace label
      yBottomLine = 320; // ----------
      yRow3Label = 350;  // time

      xTopLine = 236;
      xBottomLine = 205;

      xRow0Label = 196;
      xRow1Col1Label = 138;
      xRow1Col1Num = 125;
      xRow1Col2Label = 290;
      xRow1Col2Num = 302;
      xRow2Col1Label = 120;
      xRow2Col1Num = 110;
      xRow2Col2Label = 275;
      xRow2Col2Num = 285;
      xRow3Label = 196;
   }

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration < 3600) {
         return fontNumberHot;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
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
