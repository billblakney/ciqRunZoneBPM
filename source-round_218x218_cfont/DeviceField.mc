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
   var customFontMedium = null;
   var customFontHot = null;
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

      customFontMedium = Ui.loadResource(Rez.Fonts.robobk40numbers);
      customFontHot = Ui.loadResource(Rez.Fonts.robobk48numbers);

      yRow0Label = 17;   // zone area
      yTopLine = 34;     // ----------
      yRow1Label = 44;   // timer/BPM label
      yRow1Number = 80;  // timer/BPM value
      yMiddleLine = 109; // ----------
      yRow2Number = 141; // dist/pace value
      yRow2Label = 174;  // dist/pace label
      yBottomLine = 186; // ----------
      yRow3Label = 200;  // time

      xTopLine = 133;
      xBottomLine = 109;

      xRow0Label = 110;
      xRow1Col1Label = 86;
      xRow1Col1Num = 70;
      xRow1Col2Label = 160;
      xRow1Col2Num = 170;
      xRow2Col1Label = 74;
      xRow2Col1Num = 60;
      xRow2Col2Label = 146;
      xRow2Col2Num = 154;
      xRow3Label = 110;
   }

   /*
    * Gets the timer font.
    * 0:00-9:59     000-599
    * 10:00-59:59   600-3599
    * 1:00:00+     3600-...
    */
   function getTimerFont(duration)
   {
      if (duration >= 3600) {
         return customFontMedium;
      } else {
         return customFontHot;
      }
   }

   /*
    * Gets the heart rate font.
    */
   function getHeartRateFont(heartRate)
   {
      return customFontMedium;
//      if (heartRate != null && heartRate > 100)
//      {
//         return Gfx.FONT_NUMBER_HOT;
//      }
//      else
//      {
//         return Gfx.FONT_NUMBER_HOT;
//      }
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      if (dist.toFloat() < 10) {
         return customFontHot;
      } else {
         return customFontMedium;
      }
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      if (pace != null && pace < 10*60) {
         return customFontHot;
      } else {
         return customFontMedium;
      }
   }
}
