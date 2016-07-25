filters = angular.module 'filters', []

filters.filter 'paganition', ->
  (inputArray, selectedPage, pageSize) ->
    start = selectedPage * pageSize
    return inputArray.slice start, start + pageSize
