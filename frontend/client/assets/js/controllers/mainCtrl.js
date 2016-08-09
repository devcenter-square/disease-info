var app = angular.module('mainCtrl', ['diseaseService']);

app.controller('diseaseCtrl', function (Disease, $scope) {

    var vm = this;

    Disease.all()
        .success(function(data) {



            // bind the diseases that come back to vm.diseases
            $scope.diseases = data.diseases;

            //console.log(value);
            ////console.log(data.diseases[0]);
            console.log($scope.diseases)
        });
});

app.controller('individualDiseaseCtrl', function($scope, Disease, $routeParams) {

    var vm = this;

    Disease.get($routeParams.name)
        .success(function(data) {

            $scope.oneDisease = data;
            console.log($scope.oneDisease)
        });
});