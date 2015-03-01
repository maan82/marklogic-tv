(function(angular) {
  angular.module("upload.controllers", []);
  angular.module("upload.services", []);
  angular.module("upload.directives", []);

  var myApp = angular.module("upload", ["ngResource", "upload.controllers", "upload.services", "upload.directives", "angularFileUpload", "ui.bootstrap.datetimepicker",  "isteven-multi-select"]);
  myApp.config(function($sceProvider) {
      // Completely disable SCE.  For demonstration purposes only!
      // Do not use in new projects.
      $sceProvider.enabled(false);
  });


}(angular));
