module.controller('PasswordUpdateCtrl', ['$auth', '$scope', '$state',
  function($auth, $scope, $state) {
    $scope.updatePassword = function() {
      $auth.updatePassword($scope.passwordUpdate)
        .then(function(response) {
          $state.go('dashboard');
        })
        .catch(function(error) {
          $scope.error = error.errors[0];
        });
    };
}]);
