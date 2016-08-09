
var app = angular.module('diseaseinfo', ['ngRoute', 'ngAnimate', 'mainCtrl', 'diseaseService', 'angular-loading-bar', 'angularUtils.directives.dirPagination' ]);

app.config(function ($routeProvider, $locationProvider) {

    $locationProvider.html5Mode(true);

    $routeProvider

        .when('/', {
            templateUrl: './views/partials/home.html',
            controller: 'diseaseCtrl'
        })

        .when('/:name', {
            templateUrl: './views/partials/individualdisease.html',
            controller: 'individualDiseaseCtrl',
            controllerAs: 'individual'
        });

});

