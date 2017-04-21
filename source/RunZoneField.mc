using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Attention as Attn;
using Toybox.UserProfile as Profile;

/*
 * forerunner: width,height: 215,180
 * fenix:      width,height: 218,218
 * bravo2d:    width,height: 218,218
 *
 * for fenix and bravo:
 * - lower topline and top labels
 * - raise lowerline and lower readouts
 */
class RunZoneField extends Ui.DataField
{
   const METERS_TO_MILES=0.000621371; // TODO rm, not used
   const MILLISECONDS_TO_SECONDS=0.001;
   const COLOR_IDX_WHITE    = 0;
   const COLOR_IDX_LT_GRAY  = 1;
   const COLOR_IDX_DK_GRAY  = 2;
   const COLOR_IDX_BLACK    = 3;
   const COLOR_IDX_RED      = 4;
   const COLOR_IDX_DK_RED   = 5;
   const COLOR_IDX_ORANGE   = 6;
   const COLOR_IDX_YELLOW   = 7;
   const COLOR_IDX_GREEN    = 8;
   const COLOR_IDX_DK_GREEN = 9;
   const COLOR_IDX_BLUE     = 10;
   const COLOR_IDX_DK_BLUE  = 11;
   const COLOR_IDX_PURPLE   = 12;
   const COLOR_IDX_PINK     = 13;

   var useBlackBack = false;

   var useLapDuration = true;
   var useLapDistance = true;
   var useLapPace = true;

   var defaultBgColor = Graphics.COLOR_WHITE;
   var defaultFgColor = Graphics.COLOR_BLACK;

//   var testHeartRates = new [50];

   /* Counts number of times that onUpdate has been called. Will have a
    * value of 0 during first pass through compute and entering onUpdate,
    * and is incremented at the end of each onUpdate call.
    */
   var cycleCounter;

   /* TODO rm
    * Counter used to develop some tone code.
    */
   var testToneCounter;

   /* TODO rm
    *
    */
   var old_counter;
   // var value_picked = null;

   var currentTime = null;
   /* battery
   var battery = null;
   */
   var heartRate = null;
   var pace = null;      // seconds/mile
   var duration = null;  // seconds
   var distance = null;

   var isPaused;
   var isStopped;
   var previousTime;
   var previousDistance;
   
   var lapDuration;
   var lapDistance;
   var lapSpeed;
//   var lapPace;          // seconds/mile

   var maxPace = 3600-1;

   var split;

   var width;
   var height;

   var xTopLine;
   var xBottomLine;

   var yTopLine;
   var yMiddleLine;  // centered vertically
   var yBottomLine;

   var vOffset1 = 1; // applied to items of large rows

   var yRow0Label;
   var yRow1Label;
   var yRow1Number;
   var yRow2Label;
   var yRow2Number;
   var yRow3Label;
   
   var xRow0Label;
   var xRow1Col1Label;
   var xRow1Col1Num;
   var xRow1Col2Label;
   var xRow1Col2Num;
   var xRow2Col1Label;
   var xRow2Col1Num;
   var xRow2Col2Label;
   var xRow2Col2Num;
   var xRow3Label;

   var beginZone1;
   var beginZone2;
   var beginZone3;
   var beginZone4;
   var beginZone5;

   var hiliteZone = 0;

   var zone1BgColor = Graphics.COLOR_WHITE;
   var zone1FgColor = Graphics.COLOR_BLACK;
   var zone2BgColor = Graphics.COLOR_WHITE;
   var zone2FgColor = Graphics.COLOR_BLACK;
   var zone3BgColor = Graphics.COLOR_WHITE;
   var zone3FgColor = Graphics.COLOR_BLACK;
   var zone4BgColor = Graphics.COLOR_WHITE;
   var zone4FgColor = Graphics.COLOR_BLACK;
   var zone5BgColor = Graphics.COLOR_WHITE;
   var zone5FgColor = Graphics.COLOR_BLACK;

   /*
    * Constructor.
    */
   function initialize()
   {
      DataField.initialize();

      getUserSettings();

      if (useBlackBack)
      {
         defaultBgColor = Graphics.COLOR_BLACK;
         defaultFgColor = Graphics.COLOR_WHITE;
      }

      cycleCounter = 0;
      testToneCounter = 0;
      old_counter = 0;

      heartRate = null;
      pace = null;
      duration = 0;
      distance = 0.0;
      
      isPaused = false;
      isStopped = true;

      if (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC)
      {
         split = 1000.0;
      }
      else
      {
         split = 1609.0;
      }

//      for (var i = 0; i < 50; i++) //TODO
//      {
//         testHeartRates[i] = 120+i;
//      }
//      testHeartRates[45] = 105;
//      testHeartRates[46] = 104;
//      testHeartRates[47] = 103;
//      testHeartRates[48] = 102;
//      testHeartRates[49] = 101;
   }

   /*
    * Get user settings.
    */
   function getUserSettings()
   {

      hiliteZone = App.getApp().getProperty("hiliteZone");
//      Sys.println("hiliteZone: " + hiliteZone);

      useBlackBack = App.getApp().getProperty("useBlackBack");

      var zone1BgColorNum = App.getApp().getProperty("z1BgColor");
      var zone1FgColorNum = App.getApp().getProperty("z1FgColor");
      var zone2BgColorNum = App.getApp().getProperty("z2BgColor");
      var zone2FgColorNum = App.getApp().getProperty("z2FgColor");
      var zone3BgColorNum = App.getApp().getProperty("z3BgColor");
      var zone3FgColorNum = App.getApp().getProperty("z3FgColor");
      var zone4BgColorNum = App.getApp().getProperty("z4BgColor");
      var zone4FgColorNum = App.getApp().getProperty("z4FgColor");
      var zone5BgColorNum = App.getApp().getProperty("z5BgColor");
      var zone5FgColorNum = App.getApp().getProperty("z5FgColor");

      zone1BgColor = getColorCode(zone1BgColorNum);
      zone1FgColor = getColorCode(zone1FgColorNum);
      zone2BgColor = getColorCode(zone2BgColorNum);
      zone2FgColor = getColorCode(zone2FgColorNum);
      zone3BgColor = getColorCode(zone3BgColorNum);
      zone3FgColor = getColorCode(zone3FgColorNum);
      zone4BgColor = getColorCode(zone4BgColorNum);
      zone4FgColor = getColorCode(zone4FgColorNum);
      zone5BgColor = getColorCode(zone5BgColorNum);
      zone5FgColor = getColorCode(zone5FgColorNum);

      var sport = Profile.getCurrentSport();
//      Sys.println("currentSport: " + sport);
      var zones = Profile.getHeartRateZones(sport);

      beginZone1 = zones[0];
      beginZone2 = zones[1] + 1;
      beginZone3 = zones[2] + 1;
      beginZone4 = zones[3] + 1;
      beginZone5 = zones[4] + 1;
//      Sys.println("beginZone1: " + beginZone1);
//      Sys.println("beginZone2: " + beginZone2);
//      Sys.println("beginZone3: " + beginZone3);
//      Sys.println("beginZone4: " + beginZone4);
//      Sys.println("beginZone5: " + beginZone5);
   }
   
   /*
    * Handle timer pause.
    */
   function onTimerPause()
   {
      Sys.println("Pause");
      isPaused = true;
   }

   /*
    * Handle timer resume.
    */
   function onTimerResume()
   {
      Sys.println("Resume");
      isPaused = false;
      previousTime = Sys.getTimer();
      var info = Activity.getActivityInfo();
      previousDistance = info.elapsedDistance;
   }

   /*
    * Handle timer start.
    */
   function onTimerStart()
   {
      Sys.println("Start");
      isStopped = false;
      previousTime = Sys.getTimer();
      var info = Activity.getActivityInfo();
      previousDistance = info.elapsedDistance;
      lapSpeed = null;
   }

   /*
    * Handle timer stop.
    */
   function onTimerStop()
   {
      Sys.println("Stop");
      isStopped = true;
   }

   /*
    * Handle timer "on lap".
    */
   function onTimerLap()
   {
      Sys.println("Lap");
      previousTime = Sys.getTimer();
      lapDuration = 0;
      var info = Activity.getActivityInfo();
      previousDistance = info.elapsedDistance;
      lapDistance = 0.0;
      lapSpeed = null;
   }

   /*
    * Handle timer reset.
    */
   function onTimerReset()
   {
      Sys.println("Reset");
      lapDuration = null;
      lapDistance = null;
      lapSpeed = null;
   }

   /*
    * Compute info to be displayed.
    */
   function compute(info)
   {
      /*
       * Compute lap values if any lap fields are being used.
       */
      if ((useLapDistance || useLapDuration || useLapPace)
            && (!isPaused && !isStopped))
      {
         if (lapDuration == null)
         {
            lapDuration = 0;
         }

         var tCurrentTime = Sys.getTimer();
         if (previousTime != null)
         {
            lapDuration += (tCurrentTime - previousTime);
         }
         previousTime = tCurrentTime;

         if (lapDistance == null)
         {
            lapDistance = 0.0;
         }

         var currentDistance = info.elapsedDistance;
         if (currentDistance == null) // seem to need this
         {
            currentDistance = 0.0;
         }
         if (previousDistance != null) {
            lapDistance += (currentDistance - previousDistance);
         }
         previousDistance = currentDistance;
         
         if (lapDuration != 0)
         {
            lapSpeed = lapDistance/(lapDuration*MILLISECONDS_TO_SECONDS);
         }
         else
         {
            lapSpeed = 0;
         }
      }

      currentTime = fmtTime(Sys.getClockTime());

      /*
       * Set duration
       */
      var tDuration = 0;
      if (useLapDuration && lapDuration != null)
      {
         tDuration = lapDuration;
      }
      else
      {
         duration = info.timerTime;
      }
      duration = tDuration * MILLISECONDS_TO_SECONDS;

      /*
       * Set distance
       */
      var tDistance = 0.0;
      if (useLapDistance && lapDistance != null)
      {
         tDistance = lapDistance;
      }
      else
      {
         tDistance = info.elapsedDistance;
      }
      distance = toDist(tDistance);

      /*
       * Set pace
       */
      var tSpeed = 0.0;
      if (useLapPace && lapSpeed != null)
      {
         tSpeed = lapSpeed;
      }
      else
      {
         tSpeed = info.currentSpeed; // meters/sec
      }
      pace = toPace(tSpeed); // sec/mile

      /*
       * Set heart rate
       */
      heartRate = info.currentHeartRate;

      /*
       * Set battery
       */
      //battery = Sys.getSystemStats().battery;

      setTestValues(info);
   }

   /*
    * Set test values for items to be displayed.
    */
   function setTestValues(info)
   {

      /*
       * Use this set for "biggest values"
       */
      /*
      */
//      currentTime = "12:00pm";
//      duration = 1620; // = 27*60 + 0 -> 27:00
//      distance = "3.00";
//      heartRate = 128;
//      pace = 10*60; // 9:00
      /*
      */
      /*
      currentTime = "12:00pm";
      duration = 7688; // = 60*60 + 8*60 + 8 -> 2:08:08
      distance = "26.12";
      heartRate = 140;
      pace = 4*60 + 54; // 10:00
      */

      // clock time
      //currentTime = "00:00";

      /* battery
      // battery
      //battery = 100;
      */

      // duration
      //duration = 4088; // = 60*60 + 8*60 + 8 -> 1:08:08
      //duration = 3600; // = 60*60            -> 1:00:00
      //duration = 728;  // 728 = 12*60 + 8    ->   12:08
      //duration = 488;  // 484 = 8*60+8       ->    8:08

      // distance
      //distance = "9.99";
      //distance = "10.00";

      // heart rate
      //hiliteZone = 3;
      //heartRate = 140;
      //heartRate = 100;
      //heartRate = 88;
      //if (cycleCounter < 50)
      //{
      //   heartRate = testHeartRates[cycleCounter];
      //}

      // pace
      //pace = 8*60;  //  8:00
      //pace = 10*60; // 10:00
   }

//   function onLayout(dc)
//   {
//      setGeometryParams();
//   }

   /*
    * Sets the layout.
    */
   (:round_218x218) function onLayout(dc)
   {
//      System.println("Setting geometry for round_218x218");
      width = dc.getWidth();
      height = dc.getHeight();

//      yTopLine = 25;
//      yMiddleLine = 109;
//      yBottomLine = 193;
//
//      yRow0Label = 13;
//      yRow1Label = 34;
//      yRow1Number = 70;
//      yRow2Label = 119;
//      yRow2Number = 153;
//      yRow3Label = 205;

      yRow0Label = 13;   // zone area
      yTopLine = 25;     // ----------
      yRow1Label = 34;   // timer/BPM label
      yRow1Number = 70;  // timer/BPM value
      yMiddleLine = 109; // ----------
      yRow2Label = 119;  // dist/pace label
      yRow2Number = 153; // dist/pace value
      yBottomLine = 193; // ----------
      yRow3Label = 205;  // time

      xTopLine = 131;
      xBottomLine = 111;

      xRow0Label = 109;
      xRow1Col1Label = 96;
      xRow1Col1Num = 123;
      xRow1Col2Label = 145;
      xRow1Col2Num = 136;
      xRow2Col1Label = 83;
      xRow2Col1Num = 104;
      xRow2Col2Label = 141;
      xRow2Col2Num = 116;
      xRow3Label = 114;
   }

   /*
    * Sets the layout for all forerunners except 920xt.
    */
   (:semiround_215x180) function onLayout(dc)
   {
//      System.println("Setting geometry for semiround_215x180");
      width = dc.getWidth();
      height = dc.getHeight();

// TODO rm after test`
//      yTopLine = 19;
//      yMiddleLine = 90;
//      yBottomLine = 161;
//
//      yRow0Label = 8;
//      yRow1Number = 59;
//      yRow1Label = 29;
//      yRow2Number = 130;
//      yRow2Label = 100;
//      yRow3Label = 171;

      yRow0Label = 8;    // zone area
      yTopLine = 19;     // ----------
      yRow1Label = 29;   // timer/BPM label
      yRow1Number = 59;  // timer/BPM value
      yMiddleLine = 90;  // ----------
      yRow2Label = 100;  // dist/pace label
      yRow2Number = 130; // dist/pace value
      yBottomLine = 161; // ----------
      yRow3Label = 171;  // time

      xTopLine = 129;
      xBottomLine = 109;

      xRow0Label = 107;
      xRow1Col1Label = 94;
      xRow1Col1Num = 121;
      xRow1Col2Label = 143;
      xRow1Col2Num = 134;
      xRow2Col1Label = 81;
      xRow2Col1Num = 102;
      xRow2Col2Label = 139;
      xRow2Col2Num = 114;
      xRow3Label = 112;
   }

   /*
    * Sets the layout for vivoactive, fr920xt, epix.
    */
   (:rectangle_205x148) function onLayout(dc)
   {
//      System.println("Setting geometry for rectangle_205x148");
      width = dc.getWidth();
      height = dc.getHeight();

      yRow0Label = 5;    // zone area
      yTopLine = 15;     // ----------
      yRow1Label = 22;   // timer/BPM label
      yRow1Number = 53;  // timer/BPM value
      yMiddleLine = 76;  // ----------
      yRow2Label = 83;   // dist/pace label
      yRow2Number = 111; // dist/pace value
      yBottomLine = 133; // ----------
      yRow3Label = 140;  // time

      xTopLine = 129;
      xBottomLine = 109;

      xRow0Label = 107;
      xRow1Col1Label = 94;
      xRow1Col1Num = 121;
      xRow1Col2Label = 143;
      xRow1Col2Num = 134;
      xRow2Col1Label = 81;
      xRow2Col1Num = 102;
      xRow2Col2Label = 139;
      xRow2Col2Num = 114;
      xRow3Label = 112;
   }

   /*-------------------------------------------------------------------------
    *------------------------------------------------------------------------*/
//   (:semiround_215x180) function someFunction()
//   (:round_218x218) function someFunction()
//   (:rectangle_205x148) function someFunction()

   /*
    * Gets the pace font.
    */
   (:semiround_215x180) function getPaceFont(pace)
   {
      if (pace != null && pace < 10*60)
      {
         return Gfx.FONT_NUMBER_HOT;
      }
      else
      {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }

   /*
    * Gets the pace font.
    */
   (:round_218x218) function getPaceFont(pace)
   {
      if (pace != null && pace < 10*60)
      {
         return Gfx.FONT_NUMBER_HOT;
      }
      else {
         return Gfx.FONT_NUMBER_MEDIUM;
      }
   }

   /*
    * Gets the pace font.
    */
   (:rectangle_205x148) function getPaceFont(pace)
   {
      return Gfx.FONT_NUMBER_HOT;
   }


   /*
    * Handles "on show".
    */
   function onShow()
   {
   }

   /*
    * Handles "on hide".
    */
   function onHide()
   {
   }

   /*
    * Handles "on update".
    */
   function onUpdate(dc)
   {
      dc.setColor(defaultFgColor,defaultBgColor);
      dc.clear();

//      testTone();

      // Draw heartRate color indicator

      var zone = 0;
      var zoneLabel = "";
      var zoneColorBkg = defaultBgColor;
      var zoneColorFrg = defaultFgColor;

      if (heartRate != null) {
         if (heartRate >= beginZone5)
         {
            zone = 5;
            zoneLabel = "Zone 5";
            zoneColorBkg = zone5BgColor;
            zoneColorFrg = zone5FgColor;
         }
         else if (heartRate >= beginZone4)
         {
            zone = 4;
            zoneLabel = "Zone 4";
            zoneColorBkg = zone4BgColor;
            zoneColorFrg = zone4FgColor;
         }
         else if (heartRate >= beginZone3)
         {
            zone = 3;
            zoneLabel = "Zone 3";
            zoneColorBkg = zone3BgColor;
            zoneColorFrg = zone3FgColor;
         }
         else if (heartRate >= beginZone2)
         {
            zone = 2;
            zoneLabel = "Zone 2";
            zoneColorBkg = zone2BgColor;
            zoneColorFrg = zone2FgColor;
         }
         else if (heartRate >= beginZone1)
         {
            zone = 1;
            zoneLabel = "Zone 1";
            zoneColorBkg = zone1BgColor;
            zoneColorFrg = zone1FgColor;
         }

         dc.setColor(zoneColorBkg,zoneColorBkg);
         dc.fillRectangle(0, 0, width, yTopLine-0);
      }

      // heart rate zone
      dc.setColor(zoneColorFrg, Gfx.COLOR_TRANSPARENT);
      textC(dc, xRow0Label, yRow0Label, Gfx.FONT_XTINY,  zoneLabel);

      var font;

      // heart rate
      if (zone >= hiliteZone)
      {
         dc.setColor(zoneColorBkg, zoneColorBkg);
         dc.fillRectangle(xTopLine+1, yTopLine, width, yMiddleLine-yTopLine-1);

         dc.setColor(zoneColorFrg, Gfx.COLOR_TRANSPARENT);
      }
      else
      {
         dc.setColor(defaultFgColor, Gfx.COLOR_TRANSPARENT);
      }

      textL(dc, xTopLine+14, yRow1Label, Gfx.FONT_XTINY,  "Heart");

      if (heartRate != null && heartRate > 100)
      {
         font = Gfx.FONT_NUMBER_HOT;
      }
      else
      {
         font = Gfx.FONT_NUMBER_HOT;
      }

      textL(dc, xRow1Col2Num, yRow1Number, font,  toStr(heartRate));

      // other texts drawn in black font color
      dc.setColor(defaultFgColor, Gfx.COLOR_TRANSPARENT);

      // pace
      var tPaceFont = getPaceFont(pace);
      textL(dc, xRow2Col2Label , yRow2Label, Gfx.FONT_XTINY,  "Pace");
      textL(dc, xRow2Col2Num , yRow2Number, tPaceFont, fmtSecs(pace));

      // timer
      textR(dc, xRow1Col1Label , yRow1Label, Gfx.FONT_XTINY,  "Timer");

      // TODO offset for 10:00 vs 1:00
      if (duration >= 3600)
      {
         font = Gfx.FONT_NUMBER_MEDIUM;
      }
      else
      {
         font = Gfx.FONT_NUMBER_HOT;
      }
      textR(dc, xRow1Col1Num , yRow1Number, font,  fmtSecs(duration));

      // distance
      textR(dc, xRow2Col1Label , yRow2Label, Gfx.FONT_XTINY, "Distance");

      if (distance.toFloat() < 10)
      {
         font = Gfx.FONT_NUMBER_HOT;
      }
      else
      {
         font = Gfx.FONT_NUMBER_MEDIUM;
      }
      textR(dc, xRow2Col1Num , yRow2Number, font, distance);

      // current time
      textC(dc, xRow3Label , yRow3Label, Gfx.FONT_XTINY,  currentTime);

      // Draw lines

      dc.setPenWidth(2);
      dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);

      // horizontal lines
      dc.drawLine(0, yTopLine, width, yTopLine);
      dc.drawLine(0, yMiddleLine, width, yMiddleLine);
      dc.drawLine(0, yBottomLine, width, yBottomLine);

      // vertical lines
      dc.drawLine(xTopLine,yTopLine,xTopLine,yMiddleLine);
      dc.drawLine(xBottomLine,yMiddleLine,xBottomLine,yBottomLine);

      cycleCounter++;
   
      return true;
   }

   /*
    * Converts a speed to a pace.
    */
   function toPace(speed)
   {
      if (speed == null || speed == 0)
      {
         return null;
      }

      var pace = split / speed; // cvt meter/sec to km or mi/sec
      if (pace > maxPace)
      {
         pace = null;
      }

      return pace;
   }

   /*
    * Draws left-justified text.
    */
   function textL(dc, x, y, font, s)
   {
      if (s != null)
      {
         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
      }
   }

   /*
    * Draws right-justified text.
    */
   function textR(dc, x, y, font, s)
   {
      if (s != null)
      {
         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
      }
   }

   /*
    * Draws centered text.
    */
   function textC(dc, x, y, font, s)
   {
      if (s != null)
      {
         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
      }
   }

   /*
    * Gets string for a heart rate.
    */
   function toStr(o)
   {
      if (o != null && o > 0)
      {
         return "" + o;
      }
      else
      {
         return "---";
      }
   }

   /*
    * Gets a formatted string for a time.
    */
   function fmtTime(clock)
   {
      var h = clock.hour;
      var amPm = "";
      var timeFieldOffset = 0;

      if (!Sys.getDeviceSettings().is24Hour)
      {
         if (h == 0)
         {
            h += 12;
            amPm = "am";
         }
         else if (h < 12)
         {
            amPm = "am";
         }
         else if (h == 12)
         {
            amPm = "pm";
         }
         else // h > 12
         {
            h -= 12;
            amPm = "pm";
         }
      }

      if (h >= 10)
      {
         timeFieldOffset = 2;
      }

      return "" + h + ":" + clock.min.format("%02d") + amPm;
   }

   /*
    * Gets a formatted string to represent a time or duration.
    */
   function fmtSecs(secs)
   {
      if (secs == null)
      {
         return "----";
      }

      var s = secs.toLong();
      var hours = s / 3600;
      s -= hours * 3600;
      var minutes = s / 60;
      s -= minutes * 60;

      var fmt;
      if (hours > 0)
      {
         fmt = "" + hours + ":" + minutes.format("%02d") + ":" + s.format("%02d");
      }
      else
      {
         fmt = "" + minutes + ":" + s.format("%02d");
      }

      return fmt;
   }

   /*
    * Gets a distance string.
    */
   function toDist(dist)
   {
      if (dist == null)
      {
         return "0.00";
      }

      dist = dist / split;
      return dist.format("%.2f", dist);
   }

   /* battery
   function fmtBattery(battery) {
      var fmt = "" + battery.format("%2d") + "%";
      return fmt;
   }
   */

   /*
    * Gets a color code for a user-selected color index.
    */
   function getColorCode(color_index)
   {

      var color = Graphics.COLOR_WHITE;


      if (color_index == COLOR_IDX_WHITE) {
         color = Graphics.COLOR_WHITE;
      }
      else if (color_index == COLOR_IDX_LT_GRAY) {
         color = Graphics.COLOR_LT_GRAY;
      }
      else if (color_index == COLOR_IDX_DK_GRAY) {
         color = Graphics.COLOR_DK_GRAY;
      }
      else if (color_index == COLOR_IDX_BLACK) {
         color = Graphics.COLOR_BLACK;
      }
      else if (color_index == COLOR_IDX_RED) {
         color = Graphics.COLOR_RED;
      }
      else if (color_index == COLOR_IDX_DK_RED) {
         color = Graphics.COLOR_DK_RED;
      }
      else if (color_index == COLOR_IDX_ORANGE) {
         color = Graphics.COLOR_ORANGE;
      }
      else if (color_index == COLOR_IDX_YELLOW) {
         color = Graphics.COLOR_YELLOW;
      }
      else if (color_index == COLOR_IDX_GREEN) {
         color = Graphics.COLOR_GREEN;
      }
      else if (color_index == COLOR_IDX_DK_GREEN) {
         color = Graphics.COLOR_DK_GREEN;
      }
      else if (color_index == COLOR_IDX_BLUE) {
         color = Graphics.COLOR_BLUE;
      }
      else if (color_index == COLOR_IDX_DK_BLUE) {
         color = Graphics.COLOR_DK_BLUE;
      }
      else if (color_index == COLOR_IDX_PURPLE) {
         color = Graphics.COLOR_PURPLE;
      }
      else if (color_index == COLOR_IDX_PINK) {
         color = Graphics.COLOR_PINK;
      }
      else {
         Sys.println("ERROR: unknown color: " + color_index);
      }

      return color;
   }

//   function testTone() {
//
//      if (testToneCounter == 0)
//      {
//         Attn.playTone(Attn.TONE_KEY);
//      }
//      else if (testToneCounter == 3)
//      {
//         Attn.playTone(Attn.TONE_ALARM);
//      }
//      else if (testToneCounter == 6)
//      {
//         Attn.playTone(Attn.TONE_ALERT_LO);//3
//      }
//      else if (testToneCounter == 9)
//      {
//         Attn.playTone(Attn.TONE_ALERT_HI);//4
//      }
//      else if (testToneCounter == 12)
//      {
//         Attn.playTone(Attn.TONE_LOUD_BEEP); //1
//      }
//      else if (testToneCounter == 15)
//      {
//         Attn.playTone(Attn.TONE_CANARY); //2
//      }
//      else if (testToneCounter == 18)
//      {
//         Attn.playTone(Attn.TONE_SUCCESS);//5
//         testToneCounter -= testToneCounter + 5;
//      }
//      testToneCounter++;
//   }

//   function setupGeometry(dc) {
//
//      width = dc.getWidth();
//      height = dc.getHeight();
////      Sys.println("width,height: " + width + "," + height);
///*
// * forerunner: width,height: 215,180
// * fenix:      width,height: 218,218
// * bravo2d:    width,height: 218,218
// *
// * for fenix and bravo:
// * - lower topline and top labels
// * - raise lowerline and lower readouts
// */
//
//      var notForerunner = false;
//      if (width == 218) {
//         notForerunner = true;
//      }
//
//      yTopLine = Gfx.getFontHeight(Gfx.FONT_XTINY);
//      yMiddleLine = height/2.0;
//      yBottomLine = height - Gfx.getFontHeight(Gfx.FONT_XTINY);
//
//      xTopLine = width/2 + 22;
//      xBottomLine = width/2 + 2;
//
//      // compute yRow0Label
////      yRow0Label = Gfx.getFontHeight(Gfx.FONT_XTINY)/2 - 1;
//
//      // compute yRow3Label
//      yRow3Label = height - Gfx.getFontHeight(Gfx.FONT_XTINY)/2;
//
//      // compute yRow1Number and yRow1Label
//      var fontHeightNum = Gfx.getFontHeight(Gfx.FONT_NUMBER_HOT);
//      var fontHeightTxt = Gfx.getFontHeight(Gfx.FONT_XTINY);
//
//      yRow1Number = yMiddleLine;
//      yRow1Number = yRow1Number - fontHeightNum/2 - 3;
//      yRow1Number += vOffset1;
//
//      yRow1Label = yRow1Number - fontHeightNum/2;
//      yRow1Label = yRow1Label - fontHeightTxt/2 + 7;
//      yRow1Label += vOffset1;
//
//      // compute yRow2Number and yRow2Label
//      yRow2Label = yMiddleLine + fontHeightTxt/2 + 0;
//      yRow2Label += vOffset1;
//
//      yRow2Number = yRow2Label;
//      yRow2Number = yRow2Number + fontHeightNum/2 + 0;
//      yRow2Number += vOffset1;
//
//      if (notForerunner) {
//         yTopLine += 7;
//         yRow0Label += 5;
//
//         yRow1Label += 10;
//         yRow1Number += 4;
//
//         yRow2Number -= 8;
//
//         yBottomLine -= 7;
//         yRow3Label -= 4;
//      }
//
//Sys.println("xTopLine = " + xTopLine);
//Sys.println("xBottomLine = " + xBottomLine);
//Sys.println("yTopLine = " + yTopLine);
//Sys.println("yMiddleLine = " + yMiddleLine);
//Sys.println("yBottomLine = " + yBottomLine);
//Sys.println("yRow0Label = " + yRow0Label);
//Sys.println("yRow1Number = " + yRow1Number);
//Sys.println("yRow1Label = " + yRow1Label);
//Sys.println("yRow2Number = " + yRow2Number);
//Sys.println("yRow2Label = " + yRow2Label);
//Sys.println("yRow3Label = " + yRow3Label);
//
//xRow0Label = dc.getWidth()/2;
//xRow1Col2Label = xTopLine+14;
//xRow1Col2Num = xTopLine+5;
//xRow2Col2Label = xBottomLine+30;
//xRow2Col2Num = xBottomLine+5;
//xRow1Col1Label = xTopLine-35;
//xRow1Col1Num = xTopLine-8;
//xRow2Col1Label = xBottomLine-28;
//xRow2Col1Num = xBottomLine-7;
//xRow3Label = dc.getWidth()/2 + 5;
//Sys.println("xRow0Label = " + xRow0Label);
//Sys.println("xRow1Col1Label = " + xRow1Col1Label);
//Sys.println("xRow1Col1Num = " + xRow1Col1Num);
//Sys.println("xRow1Col2Label = " + xRow1Col2Label);
//Sys.println("xRow1Col2Num = " + xRow1Col2Num);
//Sys.println("xRow2Col1Label = " + xRow2Col1Label);
//Sys.println("xRow2Col1Num = " + xRow2Col1Num);
//Sys.println("xRow2Col2Label = " + xRow2Col2Label);
//Sys.println("xRow2Col2Num = " + xRow2Col2Num);
//Sys.println("xRow3Label = " + xRow3Label);
//   }
}
