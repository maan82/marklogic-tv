(function(angular) {
  var AppController = function($scope, $http) {
    $scope.showPlayer = false

    $scope.sort = [
        { name: "Genre",   ticked: false, value: "genre"},
        { name: "Popularity",   ticked: false, value: "popularity"},
        { name: "Start Date",   ticked: false, value: "start_date"},
        { name: "Views",   ticked: false, value: "views"}
    ];

    $scope.page = [
        { name: "Page Size 1",   ticked: false, value: "1"},
        { name: "Page Size 2",   ticked: false, value: "2"},
        { name: "Page Size 5",   ticked: false, value: "5"}
    ];

    $scope.genreSearchLang = {
        selectAll       : "Select all",
        selectNone      : "Select none",
        reset           : "Undo all",
        search          : "Type here to search...",
        nothingSelected : "Genre Search"
    }

    $scope.sortLang = {
        selectAll       : "Select all",
        selectNone      : "Select none",
        reset           : "Undo all",
        search          : "Type here to search...",
        nothingSelected : "Sort by"
    }

    $scope.pageLang = {
        selectAll       : "Select all",
        selectNone      : "Select none",
        reset           : "Undo all",
        search          : "Type here to search...",
        nothingSelected : "Page Size"
    }

    function setResponseInScope(response) {
      $scope.previous_page = getPreviousPageLink(response)
      $scope.next_page = getNextPageLink(response)
      $scope.total = response.result.total
      $scope.items = response.result.items ? response.result.items :[]
    }

    function getPreviousPageLink(response) {
      return response.result.paging && response.result.paging['previous-page'] ? response.result.paging['previous-page'] : null
    }

    function getNextPageLink(response) {
      return response.result.paging && response.result.paging['next-page'] ? response.result.paging['next-page'] : null
    }

    function setParamFromArray(params, key, value) {
      if (value && value[0] && value[0].name) {
        params = setParam(params, key, value[0].value)
      }
      return params
    }

    function setParam(params, key, value) {
      if (value) {
        params[key] = value
      }
      return params
    }

    $scope.undo = function(key) {
      $scope[key] = []
      $scope.search()
    }

    $scope.search = function() {
      var $params = {}

      $params = setParam($params, "search_text", $scope.searchText)
      $params = setParamFromArray($params, "genre", $scope.searchgenres)
      $params = setParamFromArray($params, "sort", $scope.sortoptions)
      $params = setParamFromArray($params, "page_size", $scope.pageoptions)

      $http(
        {
          method : 'GET',
          url : '/marklogic-tv/api/programmes',
          params : $params
        }
      ).
        success(function(data, status, headers, config) {
          setResponseInScope(data);
        }).
        error(function(data, status, headers, config) {
        });
    };

    $scope.getGenres = function() {
      $http(
        {
          method : 'GET',
          url : '/marklogic-tv/api/genres'
        }
      ).
        success(function(data, status, headers, config) {
          $scope.genres = []
          for(var i = 0; i < data.result.items.length; i++) {
            var item = data.result.items[i]
            $scope.genres.push({ name: item.genre.name + " (" + item.genre.count + ")" , value: item.genre.name, ticked: false})
          }
        }).
        error(function(data, status, headers, config) {
        });
    };

    $scope.nextPage = function() {
      $http(
        {
          method: 'GET',
          url: $scope.next_page
        }
      ).
        success(function(data, status, headers, config) {
          setResponseInScope(data);
        }).
        error(function(data, status, headers, config) {
        });
    };

    $scope.previousPage = function() {
      $http(
        {
          method: 'GET',
          url: $scope.previous_page
        }
      ).
        success(function(data, status, headers, config) {
          setResponseInScope(data);
        }).
        error(function(data, status, headers, config) {
        });
    };

    $scope.$watch("searchText",  function(newValue, oldValue){
      if (oldValue && (!newValue || newValue == "")) {
        $scope.search()
      }
    }, true);

    $scope.playVideo = function(item) {
      $scope.showPlayer = true
      if ($scope.showPlayer)
        $scope.player_src = item.programme.media + "?programme_id=" + item.programme.id
      else
        $scope.player_src = ""
    };

    $scope.closeVideo = function() {
      $scope.showPlayer = false
      $scope.player_src = ""
    };

    $scope.getGenres()
    $scope.search()

  };
  AppController.$inject = ['$scope', '$http'];
  angular.module("myApp.controllers").controller("AppController", AppController);
}(angular));