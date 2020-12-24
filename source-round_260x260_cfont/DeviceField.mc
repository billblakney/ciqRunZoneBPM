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

      yRow0Label = 20;   // zone area
      yTopLine = 40;     // ----------
      yRow1Label = 58;   // timer/BPM label
      yRow1Number = 96;  // timer/BPM value
      yMiddleLine = 130; // ----------
      yRow2Number = 166; // dist/pace value
      yRow2Label = 200;  // dist/pace label
      yBottomLine = 217; // ----------
      yRow3Label = 235;  // time

      xTopLine = 147;
      xBottomLine = 130;

      xRow0Label = 133;
      xRow1Col1Label = 84;
      xRow1Col1Num = 78;
      xRow1Col2Label = 190;
      xRow1Col2Num = 192;
      xRow2Col1Label = 77;
      xRow2Col1Num = 70;
      xRow2Col2Label = 183;
      xRow2Col2Num = 187;
      xRow3Label = 132;
   }

   /*-------------------------------------------------------------------------
    *------------------------------------------------------------------------*/

   /*
    * Gets the pace font.
    */
   function getHeartRateFont(heartRate)
   {
      if (heartRate != null && heartRate > 100)
      {
         return customFontHot;
      }
      else
      {
         return customFontHot;
      }
   }
   /*
    * Gets the timer font.
    * 0:00-9:59     000-599
    * 10:00-59:59   600-3599
    * 1:00:00+     3600-...
    */
   function getTimerFont(duration)
   {
      if (duration < 600) {
         return customFontHot;
      }
      if (duration < 3600) {
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
         return customFontHot;
      }
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
    * Gets the time-of-day font.
    */
   function getTimeOfDayFont()
   {
      return Gfx.FONT_MEDIUM;
   }
}
