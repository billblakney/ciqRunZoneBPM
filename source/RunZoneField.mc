using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Attention as Attn;
using Toybox.UserProfile as Profile;

class RunZoneField extends Ui.DataField
{
   enum
   {
      CUR_PACE = 0,
      LAP_PACE = 1,
      AVG_PACE = 2
   }
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
   
   const DIST_TYPE_TOTAL    = 0;
   const DIST_TYPE_LAP      = 1;
   
   const TIME_TYPE_TOTAL    = 0;
   const TIME_TYPE_LAP      = 1;
   
   const PACE_TYPE_CURRENT  = 0;
   const PACE_TYPE_AVERAGE  = 1;
   const PACE_TYPE_LAP      = 2;

   var useBlackBack = false;

   var curPaceColor = Graphics.COLOR_BLACK;
   var lapPaceColor = Graphics.COLOR_DK_BLUE;
   var avgPaceColor = Graphics.COLOR_DK_GRAY;
   var paceSwapTime = 3;
   
   var paceTypes = new [0]; // populated in getUserSettings
   var activePaceTypeIndex = 0;
   var activePaceType = CUR_PACE;
   var activePaceCycles = -1;
   
   var distLabel = "Dist";
   var timeLabel = "Timer";
   var paceLabel = "Pace";

   var defaultBgColor = Graphics.COLOR_WHITE;
   var defaultFgColor = Graphics.COLOR_BLACK;

   /* Counts number of times that onUpdate has been called. Will have a
    * value of 0 during first pass through compute and entering onUpdate,
    * and is incremented at the end of each onUpdate call.
    */
   var cycleCounter;

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

   var paceColor = getColorCode(Graphics.COLOR_BLACK);

   var maxPace = 3600-1;

   var split;

   var width;

   var yRow0Label = 13;   // zone area
   var yTopLine = 30;     // ----------
   var yRow1Label = 43;   // timer/BPM label
   var yRow1Number = 85;  // timer/BPM value
   var yMiddleLine = 120; // ----------
   var yRow2Number = 153; // dist/pace value
   var yRow2Label = 193;  // dist/pace label
   var yBottomLine = 209; // ----------
   var yRow3Label = 222;  // time

   var xTopLine = 135;
   var xBottomLine = 124;

   var xRow0Label = 120;
   var xRow1Col1Label = 80;
   var xRow1Col1Num = 70;
   var xRow1Col2Label = 176;
   var xRow1Col2Num = 180;
   var xRow2Col1Label = 77;
   var xRow2Col1Num = 70;
   var xRow2Col2Label = 168;
   var xRow2Col2Num = 177;
   var xRow3Label = 121;

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
      
      getZonesFromUserProfile();

      getUserSettings();

      if (useBlackBack)
      {
         defaultBgColor = Graphics.COLOR_BLACK;
         defaultFgColor = Graphics.COLOR_WHITE;
      }

      // paceTypes must be properly set in getUserSettings.
      activePaceTypeIndex = 0;
      activePaceType = paceTypes[0];
      updatePaceLabelAndColor();

      cycleCounter = 0;

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
   }

   /*
    * Get zones from user profile.
    */
   function getZonesFromUserProfile()
   {
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
    * Get user settings.
    */
   function getUserSettings()
   {
      if (App.getApp().getProperty("showCurPace") == true) {
        //Sys.println("using CUR_PACE");
        paceTypes.add(CUR_PACE);
      }
      if (App.getApp().getProperty("showLapPace") == true) {
        //Sys.println("using LAP_PACE");
        paceTypes.add(LAP_PACE);
      }
      if (App.getApp().getProperty("showAvgPace") == true) {
        //Sys.println("using AVG_PACE");
        paceTypes.add(AVG_PACE);
      }
      // Make sure that atleast one pace type is selected.
      if (paceTypes.size() == 0) {
        paceTypes.add(CUR_PACE);
      }

      curPaceColor = getColorCode(App.getApp().getProperty("curPaceColor"));
      lapPaceColor = getColorCode(App.getApp().getProperty("lapPaceColor"));
      avgPaceColor = getColorCode(App.getApp().getProperty("avgPaceColor"));
      paceSwapTime = App.getApp().getProperty("paceSwapTime");

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

   function updatePaceLabelAndColor()
   {
      if (activePaceType == CUR_PACE) {
         paceLabel = "Pace(C)";
         paceColor = curPaceColor;
      }
      else if (activePaceType == LAP_PACE) {
         paceLabel = "Pace(L)";
         paceColor = lapPaceColor;
      }
      else if (activePaceType == AVG_PACE) {
         paceLabel = "Pace(A)";
         paceColor = avgPaceColor;
      }
   }

   function updateActivePaceType()
   {
      if (paceTypes.size() == 1) {
         return;
      }

      activePaceCycles++;
      if (activePaceCycles == paceSwapTime)
      {
        activePaceCycles = 0;
        // Note: This relies on the pace types enum being a sequence of numbers
        // starting at zero.
        activePaceTypeIndex = (activePaceTypeIndex+1) % paceTypes.size();
        activePaceType = paceTypes[activePaceTypeIndex];
        updatePaceLabelAndColor();
      }
   }

   /*
    * Compute info to be displayed.
    */
   function compute(info)
   {
      updateActivePaceType();

      /*
       * Compute lap pace if lap pace is active
       */
      if ( activePaceType == LAP_PACE && (!isPaused && !isStopped))
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
      var tDuration = info.timerTime;
      duration = tDuration * MILLISECONDS_TO_SECONDS;

      /*
       * Set distance
       */
      var tDistance = info.elapsedDistance;
      distance = toDist(tDistance);

      /*
       * Set pace
       */
      var tSpeed = 0.0;
      if (activePaceType == LAP_PACE && lapSpeed != null)
      {
         tSpeed = lapSpeed;
      }
      else if (activePaceType == AVG_PACE)
      {
         tSpeed = info.averageSpeed; // meters/sec
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

      setFixedTestValues(info); // uncomment this for testing
//      setTestValues(info); // uncomment this for testing
//      setTestZonesValues(); // uncomment this for testing
   }

/*
   function setTestZonesValues()
   {
      var testCounter = cycleCounter;

      // heartRate
      if (testCounter % 18 < 3) {
         heartRate = beginZone1 - 1;
      } else if (testCounter % 18 < 6) {
         heartRate = beginZone1;
      } else if (testCounter % 18 < 9) {
         heartRate = beginZone2;
      } else if (testCounter % 18 < 12) {
         heartRate = beginZone3;
      } else if (testCounter % 18 < 15) {
         heartRate = beginZone4;
      } else {
         heartRate = beginZone5;
      }
   }
*/
   /*
    * Set test values for items to be displayed.
    */
   function setFixedTestValues(info)
   {
      //basics1 - zone color
      heartRate = 120;
      currentTime = "12:00pm";
      duration = 27*60;
      distance = "3.00";
      pace = 12*60 + 8;

      //basics2 - zone color change
      heartRate = 147;
      currentTime = "12:00pm";
      duration = 27*60;
      distance = "3.00";
      pace = 9*60;

      //basics3 - marathon
      heartRate = 158;
      currentTime = "12:00pm";
      duration = 2*3600 + 8*60 + 8;
      distance = "26.12";
      pace = 4*60 + 54;

      //basics4 - lap pace
      heartRate = 166;
      currentTime = "12:00pm";
      duration = 35*60 + 29;
      distance = "4.73";
      pace = 6*60 + 18;

      //basics4 - avg pace
//      heartRate = 128;
//      currentTime = "12:00pm";
//      duration = 54*60;
//      distance = "6.00";
//      pace = 9*60;

      //basics5 - avg pace
   }

   /*
    * Set test values for items to be displayed.
    */
/*
   function setTestValues(info)
   {
      var testCounter = cycleCounter;
//      var testCounter = 0;

      // heartRate
      if (testCounter % 9 < 3) {
         heartRate = 138;
      } else if (testCounter % 9 < 6) {
         heartRate = 88;
      } else {
         heartRate = 238;
      }

      // clock time
      if (testCounter % 6 < 3) {
         currentTime = "12:18am";
      } else {
         currentTime = "8:38pm";
      }

      // duration
      if (testCounter % 12 < 3) {
         duration = 599; // 0:00-9:59     000-599
      } else if (testCounter % 12 < 6) {
         duration = 3599; // 10:00-59:59   600-3599
      } else if (testCounter % 12 < 9) {
         duration = 3608; // 1:00:08+     3600-...
      } else {
         duration = 14400; // 4:00:00
      }

      // distance
      if (testCounter % 9 < 3) {
         distance = "0.00";
      } else if (testCounter % 9 < 6) {
         distance = "9.99";
      } else {
         distance = "20.00";
      }

      // pace
      if (testCounter % 9 < 3) {
         pace = 8*60 + 8;  //  8:08
      } else if (testCounter % 9 < 6) {
         pace = 10*60 + 20; // 10:00
      } else {
         pace = null; // ----
      }
   }
*/

   /*
    */
   function onLayout(dc)
   {
      width = dc.getWidth();
/*
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
*/
   }

   /*
    * Gets the heartRate font.
    */
   function getHeartRateFont(heartRate)
   {
      return Gfx.FONT_NUMBER_HOT;
   }

   /*
    * Gets the timer font.
    */
   function getTimerFont(duration)
   {
      return Gfx.FONT_NUMBER_HOT;
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
      return Gfx.FONT_NUMBER_HOT;
   }

   /*
    * Gets the zone font.
    */
   function getZoneFont()
   {
      return Gfx.FONT_XTINY;
   }

   /*
    * Gets the time-of-day font.
    */
   function getTimeOfDayFont()
   {
      return Gfx.FONT_XTINY;
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
      textC(dc, xRow0Label, yRow0Label, getZoneFont(),  zoneLabel);

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

      // heart rate
      textC(dc, xRow1Col2Label, yRow1Label, Gfx.FONT_XTINY,  "Heart");
      textC(dc, xRow1Col2Num, yRow1Number, getHeartRateFont(heartRate),  toStr(heartRate));

      // pace
      dc.setColor(paceColor, Gfx.COLOR_TRANSPARENT);
      textC(dc, xRow2Col2Label , yRow2Label, Gfx.FONT_XTINY,paceLabel);
      textC(dc, xRow2Col2Num , yRow2Number, getPaceFont(pace), fmtSecs(pace));

      // other fields use default color
      dc.setColor(defaultFgColor, Gfx.COLOR_TRANSPARENT);

      // timer
      textC(dc, xRow1Col1Label , yRow1Label, Gfx.FONT_XTINY,timeLabel);
      textC(dc, xRow1Col1Num , yRow1Number, getTimerFont(duration),  fmtSecs(duration));

      // distance
      textC(dc, xRow2Col1Label , yRow2Label, Gfx.FONT_XTINY,distLabel);
      textC(dc, xRow2Col1Num , yRow2Number, getDistFont(distance), distance);

      // current time
      textC(dc, xRow3Label , yRow3Label, getTimeOfDayFont(),  currentTime);

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
      if (speed == null || speed == 0) {
         return null;
      }
      var pace = split / speed; // cvt meter/sec to km or mi/sec
      if (pace > maxPace) {
         pace = null;
      }
      return pace;
   }

   /*
    * Draws centered text.
    */
   function textC(dc, x, y, font, s)
   {
      if (s != null) {
         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
      }
   }

   /*
    * Draws left-justified text.
    */
//   function textL(dc, x, y, font, s)
//   {
//      if (s != null) {
//         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
//      }
//   }

   /*
    * Draws right-justified text.
    */
//   function textR(dc, x, y, font, s)
//   {
//      if (s != null) {
//         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
//      }
//   }

   /*
    * Gets string for a heart rate.
    */
   function toStr(o)
   {
      if (o != null && o > 0) {
         return "" + o;
      } else {
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

      return "" + h + ":" + clock.min.format("%02d") + amPm;
   }

   /*
    * Gets a formatted string to represent a time or duration.
    */
   function fmtSecs(secs)
   {
      if (secs == null) {
         return "----";
      }

      var s = secs.toLong();
      var hours = s / 3600;
      s -= hours * 3600;
      var minutes = s / 60;
      s -= minutes * 60;

      var fmt;
      if (hours > 0) {
         fmt = "" + hours + ":" + minutes.format("%02d") + ":" + s.format("%02d");
      } else {
         fmt = "" + minutes + ":" + s.format("%02d");
      }
      return fmt;
   }

   /*
    * Gets a distance string.
    */
   function toDist(dist)
   {
      if (dist == null) {
         return "0.00";
      }
      dist = dist / split;
      return dist.format("%.2f");
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
}
