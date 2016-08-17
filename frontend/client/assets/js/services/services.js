var app = angular.module('diseaseService', [])

app.factory('Disease', function($http) {

    var diseaseFactory = {};

    // get all diseases
    diseaseFactory.all = function() {
        return $http.get('https://disease-info.herokuapp.com/diseases/');
    };

    // get a single video
    diseaseFactory.get = function(name) {
        return $http.get('https://disease-info.herokuapp.com/diseases/' + name);
    };

    return diseaseFactory;

});