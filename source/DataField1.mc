//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Attention as Attn;

class DataField1 extends Ui.DataField
{
   const METERS_TO_MILES=0.000621371; // TODO rm, not used
   const MILLISECONDS_TO_SECONDS=0.001;

   var counter;
   // var value_picked = null;

   var currentTime = null;
   var battery = null;
   var heartRate = null;
   var pace = null; // seconds/mile
   var duration = null; // seconds
   var distance = null;
   
   var maxPace = 3600-1;

   var split;

   var width;
   var height;

   var switchColumns = false;
   
   var xTopLine;
   var xBottomLine;

   var yTopLine;
   var yMiddleLine;  // centered vertically
   var yBottomLine;
   
   var vOffset1 = 1; // applied to items of large rows

   var yRow0Label;
   var yRow1Number;
   var yRow1Label;
   var yRow2Number;
   var yRow2Label;
   var yRow3Label;
   
   var firstUpdate = 1;
   
   var beginZone1;
   var beginZone2;
   var beginZone3;
   var beginZone4;
   var beginZone5;
   
   var hiliteZone = 0;

   // Constructor
   function initialize()
   {

      DataField.initialize();

      beginZone1 = Application.getApp().getProperty("beginZone1");
      beginZone2 = Application.getApp().getProperty("beginZone2");
      beginZone3 = Application.getApp().getProperty("beginZone3");
      beginZone4 = Application.getApp().getProperty("beginZone4");
      beginZone5 = Application.getApp().getProperty("beginZone5");
      hiliteZone = Application.getApp().getProperty("hiliteZone");
      Sys.println("beginZone1: " + beginZone1);
      Sys.println("beginZone2: " + beginZone2);
      Sys.println("beginZone3: " + beginZone3);
      Sys.println("beginZone4: " + beginZone4);
      Sys.println("beginZone5: " + beginZone5);
      Sys.println("hiliteZone: " + hiliteZone);

      counter = 0;

      heartRate = null;
      pace = null;
      duration = 0;
      distance = 0.0;

      if (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC)
      {
         split = 1000.0;
      }
      else
      {
         split = 1609.0;
      }
   }

   // Handle the update event
   function compute(info) {

/*
        //Cycle between Heart Rate (int), Distance (float), and elapsedTime (Duration)
        if(counter == 0) {
            if(info.currentHeartRate != null) {
                value_picked = info.currentHeartRate;
            }
        }
        if(counter == 1) {
            if(info.elapsedDistance != null) {
                value_picked = info.elapsedDistance * METERS_TO_MILES;
            }
        }
        if(counter == 2) {
            if(info.elapsedTime != null) {
                //elapsedTime is in ms.
                var options = { :seconds => info.elapsedTime *  MILLISECONDS_TO_SECONDS};
                value_picked = Time.Gregorian.duration(options);
            }
        }

        counter += 1;
        if(counter > 2) {
            counter = 0;
        }
*/
      
      currentTime = fmtTime(Sys.getClockTime());
      
      battery = Sys.getSystemStats().battery;
// TESTED
//      battery = 100;

      duration = info.timerTime * MILLISECONDS_TO_SECONDS;
// TESTED
//    duration = 4088; // = 60*60 + 8*60 + 8 -> 1:08:08
//    duration = 3600; // = 60*60            -> 1:00:00
//    duration = 728;  // 728 = 12*60 + 8    ->   12:08
//    duration = 488;  // 484 = 8*60+8       ->    8:08

      distance = toDist(info.elapsedDistance);
// TESTED
//    distance = "9.99";
//    distance = "10.00";

      heartRate = info.currentHeartRate;
// TESTED
//      hiliteZone = 3;
//    heartRate = 140;
//    heartRate = 100;
//    heartRate = 88;

      var speed = info.currentSpeed;
//speed /= 4; // increase speed to get double digit pace
//Sys.println("speed " + speed);
//Sys.println("pace " + pace);
      pace = toPace(speed); // sec/mile
// TESTED
//    pace = 8*60;  //  8:00
//    pace = 10*60; // 10:00


//        return value_picked;
    }

   function onLayout(dc) {
   }

   function onShow()
   {
   }

   function onHide() {
   }

   function onUpdate(dc) {

      if (firstUpdate ==1) {
         setupGeometry(dc);
         firstUpdate = 0;
      }

      if (counter == 0)
      {
         Attn.playTone(Attn.TONE_KEY);
      }
      else if (counter == 3)
      {
         Attn.playTone(Attn.TONE_ALARM);
      }
      else if (counter == 6)
      {
         Attn.playTone(Attn.TONE_ALERT_LO);//3
      }
      else if (counter == 9)
      {
         Attn.playTone(Attn.TONE_ALERT_HI);//4
      }
      else if (counter == 12)
      {
         Attn.playTone(Attn.TONE_LOUD_BEEP); //1
      }
      else if (counter == 15)
      {
         Attn.playTone(Attn.TONE_CANARY); //2
      }
      else if (counter == 18)
      {
         Attn.playTone(Attn.TONE_SUCCESS);//5
         counter -= counter + 5;
      }
      counter++;
      
      // Draw heartRate color indicator

      var zone = 0;
      var zoneLabel = "";
      var zoneColorBkg = Graphics.COLOR_BLUE;
      var zoneColorFrg = Graphics.COLOR_BLACK;
      if (heartRate != null) {
         if (heartRate >= beginZone5) {
            zone = 5;
            zoneLabel = "Zone 5";
            zoneColorBkg = Graphics.COLOR_DK_RED;
            zoneColorFrg = Graphics.COLOR_WHITE;
         } else if (heartRate >= beginZone4) {
            zone = 4;
            zoneLabel = "Zone 4";
            zoneColorBkg = Graphics.COLOR_RED;
            zoneColorFrg = Graphics.COLOR_WHITE;
         } else if (heartRate >= beginZone3) {
            zone = 3;
            zoneLabel = "Zone 3";
            zoneColorBkg = Graphics.COLOR_ORANGE;
            zoneColorFrg = Graphics.COLOR_WHITE;
         } else if (heartRate >= beginZone2) {
            zone = 2;
            zoneLabel = "Zone 2";
            zoneColorBkg = Graphics.COLOR_YELLOW;
         } else if (heartRate >= beginZone1) {
            zone = 1;
            zoneLabel = "Zone 1";
            zoneColorBkg = Graphics.COLOR_GREEN;
         } else {
            zoneColorBkg = Graphics.COLOR_BLUE;
         }

         dc.setColor(zoneColorBkg, Graphics.COLOR_TRANSPARENT);
         dc.fillRectangle(0, 0, width, yTopLine-0);
      }

      // heart rate zone
      dc.setColor(zoneColorFrg, Gfx.COLOR_TRANSPARENT);
      textC(dc, dc.getWidth()/2/*-49*/, yRow0Label, Gfx.FONT_XTINY,  zoneLabel);

      var font;

      // heart rate
      if (zone >= hiliteZone)
      {
         dc.setColor(zoneColorBkg, zoneColorBkg);
         if (switchColumns)
         {
            dc.fillRectangle(0, yTopLine, xTopLine-1, yMiddleLine-yTopLine-1);
         }
         else
         {
            dc.fillRectangle(xTopLine+1, yTopLine, width, yMiddleLine-yTopLine-1);
         }

         dc.setColor(zoneColorFrg, Gfx.COLOR_TRANSPARENT);
      }
      else
      {
         dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
      }

      if (switchColumns)
      {
         textR(dc, xTopLine-14, yRow1Label, Gfx.FONT_XTINY,  "Heart");
      }
      else
      {
         textL(dc, xTopLine+14, yRow1Label, Gfx.FONT_XTINY,  "Heart");
      }

      if (heartRate != null && heartRate > 100)
      {
         font = Gfx.FONT_NUMBER_HOT;
      }
      else
      {
         font = Gfx.FONT_NUMBER_HOT;
      }

      if (switchColumns)
      {
         textR(dc, xTopLine-5, yRow1Number, font,  toStr(heartRate));
      }
      else
      {
         textL(dc, xTopLine+5, yRow1Number, font,  toStr(heartRate));
      }

      // other texts drawn in black font color
      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);

      // pace
      if (switchColumns)
      {
         textR(dc, xBottomLine-30, yRow2Label, Gfx.FONT_XTINY,  "Pace");
      }
      else
      {
         textL(dc, xBottomLine+30, yRow2Label, Gfx.FONT_XTINY,  "Pace");
      }

      if (pace != null && pace < 10*60) {
         font = Gfx.FONT_NUMBER_HOT;
      }
      else {
         font = Gfx.FONT_NUMBER_MEDIUM;
      }
      if (switchColumns)
      {
         textR(dc, xBottomLine-5, yRow2Number, font, fmtSecs(pace));
      }
      else
      {
         textL(dc, xBottomLine+5, yRow2Number, font, fmtSecs(pace));
      }

      // timer
      if (switchColumns)
      {
         textL(dc, xTopLine+35, yRow1Label, Gfx.FONT_XTINY,  "Timer");
      }
      else
      {
         textR(dc, xTopLine-35, yRow1Label, Gfx.FONT_XTINY,  "Timer");
      }

      // TODO offset for 10:00 vs 1:00
      if (duration >= 3600)
      {
         font = Gfx.FONT_NUMBER_MEDIUM;
      }
      else
      {
         font = Gfx.FONT_NUMBER_HOT;
      }
      if (switchColumns)
      {
         textL(dc, xTopLine+8, yRow1Number, font,  fmtSecs(duration));
      }
      else
      {
         textR(dc, xTopLine-8, yRow1Number, font,  fmtSecs(duration));
      }

      // distance
      if (switchColumns)
      {
         textL(dc, xBottomLine+28, yRow2Label, Gfx.FONT_XTINY, "Distance");
      }
      else
      {
         textR(dc, xBottomLine-28, yRow2Label, Gfx.FONT_XTINY, "Distance");
      }

      if (distance.toFloat() < 10) {
         font = Gfx.FONT_NUMBER_HOT;
      }
      else {
         font = Gfx.FONT_NUMBER_MEDIUM;
      }
      if (switchColumns)
      {
         textL(dc, xBottomLine+7, yRow2Number, font, distance);
      }
      else
      {
         textR(dc, xBottomLine-7, yRow2Number, font, distance);
      }
      
      // current time
      textC(dc, dc.getWidth()/2 - 5, yRow3Label, Gfx.FONT_XTINY,  currentTime);
      textC(dc, dc.getWidth()/2 + 50, yRow3Label, Gfx.FONT_XTINY,  fmtBattery(battery));

      // Draw lines

      dc.setPenWidth(2);
      dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);

      // horizontal lines
      dc.drawLine(0, yTopLine, 215, yTopLine);
      dc.drawLine(0, yMiddleLine, 215, yMiddleLine);
      dc.drawLine(0, yBottomLine, 215, yBottomLine);

      // vertical lines
      dc.drawLine(xTopLine,yTopLine,xTopLine,yMiddleLine);
      dc.drawLine(xBottomLine,yMiddleLine,xBottomLine,yBottomLine);

      return true;
   }
   
   function setupGeometry(dc) {
      
      width = dc.getWidth();
      height = dc.getHeight();
      Sys.println("width,height: " + width + "," + height);

      yTopLine = Gfx.getFontHeight(Gfx.FONT_XTINY);
      yMiddleLine = height/2.0;
      yBottomLine = height - Gfx.getFontHeight(Gfx.FONT_XTINY);

      if (switchColumns)
      {
         xTopLine = width/2 -22;
         xBottomLine = width/2 - 2;
      }
      else
      {
         xTopLine = width/2 + 22;
         xBottomLine = width/2 + 2;
      }

      // compute yRow0Label
      yRow0Label = Gfx.getFontHeight(Gfx.FONT_XTINY)/2 - 1;

      // compute yRow3Label
      yRow3Label = height - Gfx.getFontHeight(Gfx.FONT_XTINY)/2;

      // compute yRow1Number and yRow1Label
      var fontHeightNum = Gfx.getFontHeight(Gfx.FONT_NUMBER_HOT);
      var fontHeightTxt = Gfx.getFontHeight(Gfx.FONT_XTINY);

      yRow1Number = yMiddleLine;
      yRow1Number = yRow1Number - fontHeightNum/2 - 3;
      yRow1Number += vOffset1;

      yRow1Label = yRow1Number - fontHeightNum/2;
      yRow1Label = yRow1Label - fontHeightTxt/2 + 7;
      yRow1Label += vOffset1;

      // compute yRow2Number and yRow2Label
      yRow2Label = yMiddleLine + fontHeightTxt/2 + 0;
      yRow2Label += vOffset1;

      yRow2Number = yRow2Label;
      yRow2Number = yRow2Number + fontHeightNum/2 + 0;
      yRow2Number += vOffset1;
   }

   function toPace(speed) {
      if (speed == null || speed == 0) {
         return null;
      }
      
      var pace = split / speed; // cvt meter/sec to km or mi/sec
      if (pace > maxPace)
      {
         pace = null;
      }

      return pace;
   }

   function textL(dc, x, y, font, s) {
      if (s != null) {
         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
      }
   }

   function textR(dc, x, y, font, s) {
      if (s != null) {
         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
      }
   }

   function textC(dc, x, y, font, s) {
      if (s != null) {
         dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
      }
   }

   function toStr(o) {
      if (o != null && o > 0) {
         return "" + o;
      } else {
         return "---";
      }
   }

   function fmtTime(clock) {

      var h = clock.hour;
      var amPm = "";
      var timeFieldOffset = 0;

      if (!Sys.getDeviceSettings().is24Hour) {
         if (h > 12) {
            h -= 12;
         } else if (h == 0) {
            h += 12;
         }
         if (h < 12) {
            amPm = "am";
         }
         else {
            amPm = "pm";
         }
      }

      if (h >= 10) {
         timeFieldOffset = 2;
      }

      return "" + h + ":" + clock.min.format("%02d") + amPm;
   }

   function fmtSecs(secs) {

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

   function toDist(dist) {
      if (dist == null) {
         return "0.00";
      }

      dist = dist / split;
      return dist.format("%.2f", dist);
   }
   
   function fmtBattery(battery) {
      var fmt = "" + battery.format("%2d") + "%";
      return fmt;
   }

}
