
var app = angular.module('diseaseinfo', ['ui.router']);

app.config(function ($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');

    $stateProvider

        .state('/', {
            url: '/',
            templateUrl: './partials/home.html'
        })

        .state('individualdisease', {
            url: '/individualdisease',
            templateUrl: './partials/individualdisease.html'
        });

});

