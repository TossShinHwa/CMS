﻿angular.module("zy.services.context", [])
.factory "context", ['$http','$localStorage',($http,$localStorage) ->

  _account = $localStorage.account || {name: 'Guest', email: undefined, avatar: '/img/avatar.png'}

  _auth = {admin : false}

  return {
    account : _account
    auth : _auth
  }
]