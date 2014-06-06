﻿angular.module("resource.users", ["ngResource"])
.factory "User", ['$resource',($resource) ->
  $resource "#{config.apiHost}/users/:id/:action", {id:'@_id'},
    update:
      method: "PUT"
    autoSignin:
      method: "POST"
      params:
        action:'autoLogin'
    signin:
      method: "POST"
      params:
        action:'login'
    signout:
      method: "POST"
      params:
        action:'logout'
]