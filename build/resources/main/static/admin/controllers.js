(function(angular) {
var UploadController = function ($scope, $upload, Item, $http) {

    $scope.genres = [
        { name: "Arts",   ticked: false},
        { name: "Comedy",   ticked: false},
        { name: "Documentaries",   ticked: false},
        { name: "Drama & Soaps",   ticked: false},
        { name: "Entertainment",   ticked: false},
        { name: "Film",   ticked: false},
        { name: "Food",   ticked: false},
        { name: "History",   ticked: false},
        { name: "Lifestyle",   ticked: false},
        { name: "Music",   ticked: false},
        { name: "News",   ticked: false},
        { name: "Science & Nature",   ticked: false},
        { name: "Sport",   ticked: false}
    ];

    $scope.load = function (files, images){
        $scope.upload($scope.files, $scope.images);
    };

    $scope.upload = function (files, images) {
        if (files && files.length && images && images.length) {
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var image =  images[i];
                var method;
                if ($scope.id) {
                  method = "PUT"
                  media = $scope.media
                  image = $
                } else {
                  method= "POST"
                }

                var $gns = [];
                angular.forEach( $scope.selectedgenres, function( value, key ) {
                  $gns.push(value.name)
                });
                $upload.upload({
                    url: '/marklogic-tv/api/admin/programmes',
                    method : method,
                    fields:
                      {'programme':
                          {'programme' :
                            {
                              "id" : "{id}",
                              "title": $scope.title,
                              "synopsis" : $scope.synopsis,
                              "start-date" : $scope.start_date,
                              "end-date" : $scope.end_date,
                              "genres" : $gns,
                              "media" : "/app/media_asset/{media}",
                              "image" : "/app/image/{image}",
                              "views" : 0,
                              "popularity" : 0
                            }
                          },
                        'id' : $scope.id
                      },
                    file: [image, file]
                }).progress(function (evt) {
                    var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
                    console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name);
                }).success(function (data, status, headers, config) {
                    console.log('file ' + config.file.name + 'uploaded. Response: ' + data);
                    Item.query(function(response) {
                        $scope.items = getItems(response);
                    });

                });
            }
        }
    };

    $scope.showPlayer = false
    Item.query(function(response) {
      $scope.items = getItems(response);
      $scope.previous_page = "fkhjdsajk"
    });

    $scope.searchItem = function(searchText) {
      $http(
        {
          method: 'GET',
          url: '/marklogic-tv/api/admin/programmes',
          params: {
            search_text : searchText
          }
        }
      ).
        success(function(data, status, headers, config) {
          $scope.items = getItems(data);
        }).
        error(function(data, status, headers, config) {
        });
    };

    $scope.$watch("searchText",  function(newValue, oldValue){
      if (oldValue && (!newValue || newValue == "")) {
        Item.query(function(response) {
          $scope.items = getItems(response);
        });
      }
    }, true);

    $scope.playVideo = function(item) {
      $scope.showPlayer = true
      if ($scope.showPlayer)
        $scope.player_src = item.programme.media
      else
        $scope.player_src = ""
    };

    $scope.closeVideo = function() {
      $scope.showPlayer = false
      $scope.player_src = ""
    };

    $scope.deleteItem =  function(item) {
      Item.remove({id:item.programme.id}, function(response) {
        Item.query(function(response) {
          $scope.items = getItems(response);
        });
      });
    };

    function getItems(response) {
      return response.result.items ? response.result.items :[]
    }


};


  UploadController.$inject = ['$scope', '$upload', 'Item', '$http'];

  angular.module("upload.controllers").controller("UploadController", UploadController);

}(angular));