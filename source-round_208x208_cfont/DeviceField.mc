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
   var fontNumberMedium = null;
   var fontNumberHot = null;
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

      fontNumberMedium = Ui.loadResource(Rez.Fonts.robobk40numbers);
      fontNumberHot = Ui.loadResource(Rez.Fonts.robobk48numbers);

      yRow0Label = 17;   // zone area
      yTopLine = 33;     // ----------
      yRow1Label = 43;   // timer/BPM label
      yRow1Number = 76;  // timer/BPM value
      yMiddleLine = 104; // ----------
      yRow2Number = 134; // dist/pace value
      yRow2Label = 165;  // dist/pace label
      yBottomLine = 175; // ----------
      yRow3Label = 191;  // time

      xTopLine = 127;
      xBottomLine = 106;

      xRow0Label = 110;     // zone
      xRow1Col1Label = 83;  // timer lbl
      xRow1Col1Num = 65;    // timer val
      xRow1Col2Label = 157; // hr lbl
      xRow1Col2Num = 162;   // hr val
      xRow2Col1Label = 74;  // dist lbl
      xRow2Col1Num = 60;    // dist val
      xRow2Col2Label = 146; // pace lbl
      xRow2Col2Num = 152;   // pace val
      xRow3Label = 106;     // time
   }

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration >= 3600) {
         return fontNumberMedium;
      } else {
         return fontNumberHot;
      }
   }

   /*
    * Gets the heart rate font.
    */
   function getHeartRateFont(heartRate)
   {
      return fontNumberHot;
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      if (dist.toFloat() < 10) {
         return fontNumberHot;
      } else {
         return fontNumberMedium;
      }
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      if (pace != null && pace < 10*60) {
         return fontNumberHot;
      } else {
         return fontNumberMedium;
      }
   }
}
