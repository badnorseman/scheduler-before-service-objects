module.controller('MenuCtrl', ['$scope',
  function ($scope) {
    $scope.menu = [
      {
        "title": "Users",
        "sref": "users",
        "icon": "icon-users"
      },
      {
        "title": "Log Out",
        "sref": "logout",
        "icon": "icon-lock"
      }
    ];
}]);
