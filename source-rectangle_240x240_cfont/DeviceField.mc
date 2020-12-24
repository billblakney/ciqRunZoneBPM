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
   var fontNumMedium = null;
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

      fontNumMedium = Ui.loadResource(Rez.Fonts.robobk48numbers);

      yRow0Label = 13;   // zone area
      yTopLine = 30;     // ----------
      yRow1Label = 43;   // timer/BPM label
      yRow1Number = 85;  // timer/BPM value
      yMiddleLine = 120; // ----------
      yRow2Number = 155; // dist/pace value
      yRow2Label = 193;  // dist/pace label
      yBottomLine = 209; // ----------
      yRow3Label = 224;  // time

      xTopLine = 138;
      xBottomLine = 113;

      xRow0Label = 120;
      xRow1Col1Label = 72;
      xRow1Col1Num = 68;
      xRow1Col2Label = 176;
      xRow1Col2Num = 180;
      xRow2Col1Label = 63;
      xRow2Col1Num = 57;
      xRow2Col2Label = 168;
      xRow2Col2Num = 165;
      xRow3Label = 120;
   }

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration != null && duration < 3600) {
         return fontNumMedium;
      } else {
         return Gfx.FONT_NUMBER_HOT;
      }
   }

   /*
    * Gets the pace font.
    */
   function getHeartRateFont(heartRate)
   {
      return fontNumMedium;
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      return fontNumMedium;
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      return fontNumMedium;
   }
}
