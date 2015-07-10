module.controller('OAuthCtrl', ['$auth', '$scope', '$state', '$stateParams',
  function($auth, $scope, $state, $stateParams) {
    $auth.authenticate($stateParams.provider)
      .then(function(response) {
        $state.go('dashboard');
      })
      .catch(function(error) {
        $scope.error = error.errors[0];
      });
}]);
