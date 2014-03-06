﻿// Generated by CoffeeScript 1.6.3
angular.module('main.controllers', ['resource.channels', 'resource.users', "ChannelServices"]).controller('GlobalController', [
  "$scope", "$http", "$location", '$window', "Channel", "account", "$timeout", "channel", function($scope, $http, $location, $window, Channel, account, $timeout, channel) {
    account.get().then(function(data) {
      return $scope.User = data;
    });
    channel.get().then(function(data) {
      return $scope.Channels = data;
    });
    $scope.search = function() {
      return $location.path("/search/" + $scope.key);
    };
    $scope.login = function() {
      return $window.location.href = '/admin/';
    };
    $scope.isActive = function(route) {
      return route === $location.path();
    };
    $scope.isActiveChannel = function(channel) {
      if (channel.IsDefault && ($location.path() === "/" || $location.path() === "/list")) {
        return true;
      }
      if ($location.path().indexOf(channel.Url) > -1) {
        return true;
      }
      return $location.path().indexOf("/post") > -1 && channel.Url.indexOf($scope.channelUrl) > -1;
    };
    return $scope.$on("ChannelChange", function(event, channel) {
      return $scope.channelUrl = channel.Url;
    });
  }
]);
