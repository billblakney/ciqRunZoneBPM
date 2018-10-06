using Toybox.Application as App;using Toybox.System as Sys;

class RunZoneApp extends App.AppBase
{

   function initialize()
   {
      AppBase.initialize();
   }

   function onStart(state) {
        return false;
    }

   function getInitialView() {
        return [new RunZoneField()];
    }

   function onStop(state) {
        return false;
    }
}