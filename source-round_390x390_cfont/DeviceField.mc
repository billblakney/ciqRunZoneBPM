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
//   var customFontMedium = null;
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

//      customFontMedium = Ui.loadResource(Rez.Fonts.testfont);
      customFontHot = Ui.loadResource(Rez.Fonts.robobk76numbers);

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
    * 0:00-9:59     000-599
    * 10:00-59:59   600-3599
    * 1:00:00+     3600-...
    */
   function getTimerFont(duration)
   {
      if (duration < 3600) {
         return customFontHot;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }

   /*
    * Gets the heartRate font.
    */
   function getHeartRateFont(heartRate)
   {
      return customFontHot;
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
         return customFontHot;
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
         return customFontHot;
      }
   }

   /*
    * Gets the time-of-day font.
    */
   function getTimeOfDayFont()
   {
      return Gfx.FONT_MEDIUM;
   }
}
