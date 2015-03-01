(function(angular) {

var videoLoader = function(){
  return function (scope, element, attrs){
    scope.$watch("player_src",  function(newValue, oldValue){ //watching the scope url value
      element[0].children[0].attributes[3].value=newValue; //set the URL on the src attribute
      if (newValue && newValue != "") {
        element[0].load();
        element[0].play();
      } else {
        element[0].pause();
      }
    }, true);
  }
};

angular.module("upload.directives").directive("videoLoader", videoLoader);
}(angular));