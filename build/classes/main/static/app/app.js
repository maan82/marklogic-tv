(function(angular) {
  angular.module("myApp.controllers", []);
  angular.module("myApp.directives", []);

  var myApp = angular.module("myApp", ["ngResource", "myApp.controllers", "myApp.directives", "isteven-multi-select"]);
  myApp.config(function($sceProvider) {
      // Completely disable SCE.  For demonstration purposes only!
      // Do not use in new projects.
      $sceProvider.enabled(false);
  });

}(angular));