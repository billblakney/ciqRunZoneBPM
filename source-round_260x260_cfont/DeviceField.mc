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

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      if (duration < 3600) {
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
      return fontNumberHot;
   }

   /*
    * Gets the distance font.
    */
   function getDistFont(dist)
   {
      return fontNumberHot;
   }

   /*
    * Gets the pace font.
    */
   function getPaceFont(pace)
   {
      return fontNumberHot;
   }

   /*
    * Gets the time-of-day font.
    */
   function getTimeOfDayFont()
   {
      return Gfx.FONT_MEDIUM;
   }
}
