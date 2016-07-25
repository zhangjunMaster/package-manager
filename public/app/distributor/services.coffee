services = angular.module 'services', ['ngResource']

services.factory 'Distributor', ($resource) ->
  $resource '/rest/distributor/:id', null,
    update: {method: 'PUT'}
