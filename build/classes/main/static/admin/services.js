(function(angular) {
  var ItemFactory = function($resource) {
    return $resource('/marklogic-tv/api/admin/programmes/:id', {
      id: '@id'
    }, {
      query: {
        method: "GET",
        isArray:false
      },
      update: {
        method: "PUT"
      },
      remove: {
        method: "DELETE"
      }
    });
  };
  
  ItemFactory.$inject = ['$resource'];
  angular.module("upload.services").factory("Item", ItemFactory);
}(angular));