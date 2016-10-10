//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application as App;using Toybox.System as Sys;

class DataField1App extends App.AppBase
{

   function initialize()
   {
      AppBase.initialize();
   }

   function onStart(state) {
    	Sys.println("onStart ==========");
        return false;
    }

   function getInitialView() {
        return [new DataField1()];
    }

   function onStop(state) {
        return false;
    }
}