﻿angular.module('gallery-list',['resource.galleries'])

.config(["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/gallery",
    templateUrl: "/app/gallery/list/gallery-list.tpl.html"
    controller: 'GalleryCtrl'
    resolve :
      galleries : ["$q", "Galleries", ($q, Galleries)->
        deferred = $q.defer()
        Galleries.list (data) ->
          deferred.resolve data.value
        deferred.promise
      ]
])

.controller('GalleryCtrl',
["$scope", "galleries", ($scope, galleries) ->
  $scope.list = galleries
])
