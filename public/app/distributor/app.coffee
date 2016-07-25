app = angular.module 'app', ['ngRoute', 'controllers', 'filters']

app.config ($routeProvider) ->
  $routeProvider.when '/',
    controller: 'ListController'
    templateUrl: '/app/distributor/tpl/list.tpl.html'

