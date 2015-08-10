﻿angular.module('article-edit',['resource.articles','resource.categories'])

.factory("TranslateService", ["$http", ($http) ->
  translate: (key) ->
    $http
      method: "JSONP"
      url: "http://api.microsofttranslator.com/V2/Ajax.svc/Translate?oncomplete=JSON_CALLBACK&appId=A4D660A48A6A97CCA791C34935E4C02BBB1BEC1C&from=zh-cn&to=en&text=" + key
])

.config(["$routeProvider", ($routeProvider) ->
  $routeProvider
    .when "/article/new",
      templateUrl: "/app/article/edit/article-edit.tpl.html"
      controller: 'ArticleEditCtrl'
    .when "/article/:id",
      templateUrl: "/app/article/edit/article-edit.tpl.html"
      controller: 'ArticleEditCtrl'
])

.controller('ArticleEditCtrl',
["$scope","$routeParams","$window","$location","$rootScope","$fileUploader","Articles","Categories","$timeout","TranslateService", "messager", "context"
($scope,$routeParams,$window,$location,$rootScope,$fileUploader,Articles,Categories,$timeout,TranslateService, messager, context) ->
  Categories.list (categories) ->
    $scope.categories = categories.value
    if $routeParams.id
      Articles.get
        id : $routeParams.id
      , (data)->
          data.editor = ''  unless data.editor
          $scope.entity = data
          if $scope.entity.meta.tags
            $scope.tags = $scope.entity.meta.tags.join(',')
          unless $scope.entity.meta.author
            $scope.entity.meta.author = context.account.name
    else
      $scope.entity =
        meta :
          author: context.account.name
        date: new Date()
        editor: ''
        comments : []

  $scope.submit = ->
    $scope.isSubmit = true
    return if $scope.form.$invalid
    return if !$scope.entity.category

    if $scope.uploader.getNotUploadedItems().length
      $scope.uploader.uploadAll()
    else
      save()

  save = ->
    entity = $scope.entity
    if $scope.tags
      $scope.entity.meta.tags = $scope.tags.split(',')

    if $routeParams.id
      Articles.put entity, (data) ->
        $window.location.href = "#{config.url.public}/post/#{data.url}"
    else
      Articles.post entity, (data) ->
        $window.location.href = "#{config.url.public}/post/#{data.url}"

  $scope.remove = ->
    messager.confirm ->
      entity=$scope.entity
      Articles.delete { id: entity.id }, (data)->
        messager.success "Delete post successfully."
        $location.path("/article")

  #上传图片
  $scope.uploader = $fileUploader.create
    scope: $scope
    url: "#{config.url.api}/FileManage/upload"

  $scope.uploader.bind('success', (event, xhr, item, res) ->
    $scope.entity.Thumbnail = res.result
    save()
  )

  $scope.removeThumbnail = ()->
    $scope.entity.Thumbnail=undefined

  #根据title翻译url.
  $scope.$watch 'entity.title', ->
    if $scope.entity and $scope.entity.title and !$scope.entity.url
      $scope.translating = true
      TranslateService.translate($scope.entity.title)
      .success (data) ->
        data = $.trim(data)
        data = data.toLowerCase()
        data = data.replace(/[^_a-zA-Z\d\s]/g, '')
        data = data.replace(/[\s]/g, "-")
        $scope.entity.url = data
        $scope.translating = false
      .error (err) ->
        $scope.translating = false
    else if $scope.entity and !$scope.entity.title
      $scope.entity.url = undefined
])

