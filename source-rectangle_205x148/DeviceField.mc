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

   /*
    * Sets the layout for vivoactive, fr920xt, epix.
    */
   function onLayout(dc)
   {
      RunZoneField.onLayout(dc);

      yRow0Label = 5;    // zone area
      yTopLine = 15;     // ----------
      yRow1Label = 22;   // timer/BPM label
      yRow1Number = 53;  // timer/BPM value
      yMiddleLine = 76;  // ----------
      yRow2Label = 83;   // dist/pace label
      yRow2Number = 111; // dist/pace value
      yBottomLine = 133; // ----------
      yRow3Label = 140;  // time

      xTopLine = 119;
      xBottomLine = 105;

      xRow0Label = 107;
      xRow1Col1Label = 64;
      xRow1Col1Num = 61;
      xRow1Col2Label = 160;
      xRow1Col2Num = 161;
      xRow2Col1Label = 60;
      xRow2Col1Num = 55;
      xRow2Col2Label = 159;
      xRow2Col2Num = 152;
      xRow3Label = 100;
   }

   /*-------------------------------------------------------------------------
    *------------------------------------------------------------------------*/

   /*
    * Gets the pace font.
    */
   function getHeartRateFont(heartRate)
   {
      return Gfx.FONT_NUMBER_HOT;
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
    * Gets the timer font.
    * 0:00-9:59     000-599
    * 10:00-59:59   600-3599
    * 1:00:00+     3600-...
    */
   function getTimerFont(duration)
   {
      if (duration >= 3600) {
         return Gfx.FONT_NUMBER_MEDIUM;
      } else {
         return Gfx.FONT_NUMBER_HOT;
      }
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      return Gfx.FONT_NUMBER_HOT;
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      if (dist.toFloat() < 10) {
         return Gfx.FONT_NUMBER_HOT;
      } else {
         return Gfx.FONT_NUMBER_HOT;
      }
   }
}
