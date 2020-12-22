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

   function onLayout(dc)
   {
      RunZoneField.onLayout(dc);

      yRow0Label = 13;   // zone area
      yTopLine = 25;     // ----------
      yRow1Label = 34;   // timer/BPM label
      yRow1Number = 70;  // timer/BPM value
      yMiddleLine = 109; // ----------
      yRow2Number = 141; // dist/pace value
      yRow2Label = 181;  // dist/pace label
      yBottomLine = 193; // ----------
      yRow3Label = 205;  // time

      xTopLine = 131;
      xBottomLine = 109;

      xRow0Label = 109;
      xRow1Col1Label = 86;
      xRow1Col1Num = 70;
      xRow1Col2Label = 160;
      xRow1Col2Num = 166;
      xRow2Col1Label = 74;
      xRow2Col1Num = 62;
      xRow2Col2Label = 144;
      xRow2Col2Num = 157;
      xRow3Label = 109;
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
//      if (pace != null && pace < 10*60) {//TODO
//         return Gfx.FONT_NUMBER_HOT;
//      } else {
//         return Gfx.FONT_NUMBER_MEDIUM;
//      }
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      if (dist.toFloat() < 10) {
         return Gfx.FONT_NUMBER_HOT;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }
}
