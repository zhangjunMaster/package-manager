controllers = angular.module 'controllers', ['services', 'ui.bootstrap']

controllers.controller 'ListController', ($scope, $modal, Distributor, User) ->
  $scope.criteria = {}
  $scope.profitList = []
  $scope.admin = admin

  loadData = ->
    $scope.distributorList = Distributor.query()
  loadData()

  $scope.distributorList.$promise.then ->
    $scope.selectedPage = 0
    $scope.pageSize = 20
    $scope.totalPage = Math.ceil $scope.distributorList.length / $scope.pageSize
    $scope.$watch 'criteria.name', ->
      $scope.selectedPage = 0
    $scope.previous = ->
      $scope.selectedPage -= 1 if $scope.selectedPage > 0
    $scope.next = ->
      $scope.selectedPage += 1 if $scope.selectedPage < $scope.totalPage - 1

  $scope.new = ->
    modalInstance = $modal.open
      controller: 'NewController'
      templateUrl: '/app/distributor/tpl/new.tpl.html'
    modalInstance.result.then ->
      loadData()

  $scope.reset = (distributor)->
    if distributor.users?
      if confirm '由你填写？'
        _.each distributor.users, (user)->
          passwd = (Math.floor(Math.random() * 10) for i in [0...6]).join ''
          User.update {id: user.id}, {passwd}, ->
            user.passwd = passwd
            alert '由你填写'
          , ->
            alert '由你填写'

  $scope.delete = (distributor) ->
    if distributorNameInput = prompt "确定删除【#{distributor.name}】吗？\n\n请输入渠道名称确定删除："
      if distributorNameInput == distributor.name
        Distributor.delete({id: distributor.id}).$promise.then ->
          alert "删除成功"
          loadData()
        , (res) ->
          alert "删除失败：#{JSON.stringify res.data}"
