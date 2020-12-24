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

      yRow0Label = 8;    // zone area
      yTopLine = 19;     // ----------
      yRow1Label = 29;   // timer/BPM label
      yRow1Number = 59;  // timer/BPM value
      yMiddleLine = 90;  // ----------
      yRow2Number = 117; // dist/pace value
      yRow2Label = 149;  // dist/pace label
      yBottomLine = 161; // ----------
      yRow3Label = 171;  // time

      xTopLine = 129;
      xBottomLine = 100;

      xRow0Label = 107;
      xRow1Col1Label = 75;
      xRow1Col1Num = 66;
      xRow1Col2Label = 161;
      xRow1Col2Num = 165;
      xRow2Col1Label = 63;
      xRow2Col1Num = 55;
      xRow2Col2Label = 146;
      xRow2Col2Num = 151;
      xRow3Label = 112;
   }

   /*
    * Gets the timer font.
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
         return Gfx.FONT_NUMBER_HOT;
      } else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      return Gfx.FONT_NUMBER_HOT;
   }
}
