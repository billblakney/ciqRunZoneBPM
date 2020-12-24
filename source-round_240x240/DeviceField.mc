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

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration < 600) {
         return Gfx.FONT_NUMBER_HOT;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }

   /*
    * Gets the heartRate font.
    */
   function getHeartRateFont(heartRate)
   {
      return Gfx.FONT_NUMBER_HOT;
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      if (dist.toFloat() < 10) {
         return Gfx.FONT_SYSTEM_NUMBER_HOT;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
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
}
