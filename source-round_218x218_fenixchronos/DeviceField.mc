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
      yTopLine = 30;     // ----------
      yRow1Label = 39;   // timer/BPM label
      yRow1Number = 79;  // timer/BPM value
      yMiddleLine = 109; // ----------
      yRow2Number = 142; // dist/pace value
      yRow2Label = 179;  // dist/pace label
      yBottomLine = 191; // ----------
      yRow3Label = 203;  // time

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

   /*
    * Gets the pace font.
    */
   function getHeartRateFont(heartRate)
   {
      if (heartRate != null && heartRate > 100)
      {
         return Gfx.FONT_NUMBER_MEDIUM; // "158"
      }
      else
      {
         return Gfx.FONT_NUMBER_HOT; // "88"
      }
   }
   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration >= 3600) {
         return Gfx.FONT_NUMBER_MEDIUM; // "1:00:00"
      } else {
         return Gfx.FONT_NUMBER_HOT; // "59:88", "9:59"
      }
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      if (pace != null && pace < 10*60) {
         return Gfx.FONT_NUMBER_HOT;
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
         return Gfx.FONT_NUMBER_HOT;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }
}
