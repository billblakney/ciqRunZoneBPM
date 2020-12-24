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
   var fontNumberHot = null;
   var fontNumberMedium = null;
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
      
      fontNumberHot = Ui.loadResource(Rez.Fonts.robobk48numbers);
      fontNumberMedium = Ui.loadResource(Rez.Fonts.robobk40numbers);

      yRow0Label = 18;   // zone area
      yTopLine = 35;     // ----------
      yRow1Label = 48;   // timer/BPM label
      yRow1Number = 85;  // timer/BPM value
      yMiddleLine = 120; // ----------
      yRow2Number = 153; // dist/pace value
      yRow2Label = 187;  // dist/pace label
      yBottomLine = 201; // ----------
      yRow3Label = 218;  // time

      xTopLine = 135;
      xBottomLine = 124;

      xRow0Label = 122;
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
      if (duration < 3600) {           // "59:59"
         return fontNumberHot;
      } else {
         return fontNumberMedium;
      }
   }

   /*
    * Gets the heartRate font.
    */
   function getHeartRateFont(heartRate)
   {
       if (heartRate != null && heartRate > 99) {
          return fontNumberHot;
       } else {
          return fontNumberHot;
       }
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      if (dist.toFloat() < 10) { // "8.98"
         return fontNumberHot;
      } else {                                 // "26.02"
         return fontNumberHot;
      }
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      if (pace != null && pace < 10*60) { // "8:38"
        return fontNumberHot;
      } else {                            // "12:38"
        return fontNumberHot;
      }
   }

   /*
    * Gets the time-of-day font.
    */
   function getTimeOfDayFont()
   {
      return Gfx.FONT_TINY;
   }
}
