﻿angular.module('article-list', ['resource.articles'])

.config(["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when '/article',
      templateUrl: '/app/article/list/article-list.tpl.html'
      controller: 'ArticleListCtrl'
])

.controller('ArticleListCtrl',
['$scope', "Articles", ($scope, Articles) ->
  $scope.setPage = (pageNo) ->
    Articles.list
      $skip: (pageNo - 1) * 10
      $top: 10
      $count: true
    ,(data) ->
      $scope.data = data

  $scope.setPage 1
])
