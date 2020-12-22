using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Attention as Attn;
using Toybox.UserProfile as Profile;

/*
 * DeviceField for round_240x240
 */
class DeviceField extends RunZoneField
{
   var testFont = null;
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
      
//      testFont = Ui.loadResource(Rez.Fonts.verdana62numbers);
      testFont = Ui.loadResource(Rez.Fonts.robocn62numbers);

      yRow0Label = 13;   // zone area
      yTopLine = 30;     // ----------
      yRow1Label = 43;   // timer/BPM label
      yRow1Number = 85;  // timer/BPM value
      yMiddleLine = 120; // ----------
      yRow2Number = 153; // dist/pace value
      yRow2Label = 193;  // dist/pace label
      yBottomLine = 209; // ----------
      yRow3Label = 222;  // time

      xTopLine = 135;
      xBottomLine = 124;

      xRow0Label = 120;
      xRow1Col1Label = 80;
      xRow1Col1Num = 70;
      xRow1Col2Label = 176;
      xRow1Col2Num = 180;
      xRow2Col1Label = 77;
      xRow2Col1Num = 70;
      xRow2Col2Label = 168;
      xRow2Col2Num = 177;
      xRow3Label = 121;
   }

   /*-------------------------------------------------------------------------
    *------------------------------------------------------------------------*/

   /*
    * Gets the pace font.
    */
   function getHeartRateFont(heartRate)
   {
   System.println("hello in, heartRate=" + heartRate);
       if (heartRate != null && heartRate > 99) {
          return testFont;
//          return Gfx.FONT_NUMBER_HOT;
//          return Gfx.FONT_NUMBER_MEDIUM;
       } else {
//          return testFont;
          return Gfx.FONT_NUMBER_HOT;
       }
   System.println("hello out");
   }
   /*
    * Gets the timer font.
    * 0:00-9:59     000-599
    * 10:00-59:59   600-3599
    * 1:00:00+     3600-...
    */
   function getTimerFont(duration)
   {
      return Gfx.FONT_NUMBER_MEDIUM;
//      return testFont;
   /*
      if (duration < 600) {
         return Gfx.FONT_NUMBER_HOT;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
      */
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      if (pace != null && pace < 10*60) {
//        return testFont;
         return Gfx.FONT_NUMBER_MEDIUM;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      if (dist.toFloat() < 10) {
         return Gfx.FONT_SYSTEM_NUMBER_MEDIUM;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }
}
