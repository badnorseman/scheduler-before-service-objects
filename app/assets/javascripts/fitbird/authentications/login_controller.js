module.controller('LoginCtrl', ['$auth', '$scope', '$state',
  function($auth, $scope, $state) {
    $scope.submitLogin = function() {
      $auth.submitLogin($scope.login)
        .then(function(response) {
          $state.go('dashboard');
        })
        .catch(function(error) {
          $scope.error = error.errors[0];
        });
    };
}]);
