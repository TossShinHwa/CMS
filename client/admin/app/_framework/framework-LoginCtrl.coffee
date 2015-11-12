angular.module("framework.controllers.login",['ngRoute'])

.config(["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when("/login",
      template: ""
      controller: ->)
])

.controller('LoginCtrl',["$scope", "$rootScope", "security", "context"
($scope,$rootScope,security, context) ->
  $scope.login = ->
    $scope.error = ''
    security.login($scope.user).then (data)->
      context.account = data
      context.auth.admin = true
      $rootScope.$broadcast "loginSuccessed"
    , () ->
      $scope.user.Password = ''
      $scope.error = "Username or password wrong."

  $scope.logout = ->
    context.auth.admin = false
    security.logoff().then () ->
      $rootScope.$broadcast "logoutSuccessed"
])
