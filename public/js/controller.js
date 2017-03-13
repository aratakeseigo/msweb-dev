var app = angular.module('testApp', ['ngRoute', 'ui.bootstrap']);
  app.config(['$routeProvider', function($routeProvider) {
    $routeProvider
      .when('/main/', {templateUrl: 'main.html'})
      .when('/employee', {templateUrl: 'employee.html', controller: 'confirmCtrl'})
      .when('/group/', {templateUrl: 'group.html'})
      .when('/confirm', {templateUrl: 'confirm.html', controller: 'confirmCtrl'})
      .otherwise({redirectTo: '/main/'});
   }]);
  app.controller('myController',['$http', '$location', function($http, $location) {
     this.sendMail = function() {
       var d = this;
       // TODO メールAPIと通信(手前でemployeeリソースからGET?)
       $http.get('mail/confirmations/')
       .success(function() {

       });
       d.modalToggle();
     };
     this.modalToggle = function () {
       $('.modal').toggle();
     };
  }]);
  // 確認画面専用コントローラー
  app.controller('confirmCtrl', ['$http', '$scope', function($http, $scope) {
    var d = this;
    $scope.json = [];
    // 安否一覧取得
    $scope.getConfirmation = function() {
      // APIコール
      $http.get('/mail/confirmations/')
      .success(function(data) {
        $scope.json = data;
      })
      // TODO API出来てないので絶対エラー
      .error(function(data) {
        $scope.json =  [{_id: "00001", name: "下田雅人", condition: "無事", comment: "無事です"},
                      {_id: "00002", name: "ダイナミック太郎", condition: "重傷", comment: ""}];
      });
    };
    $scope.getConfirmation();
  }]);
  app.directive('route',['$location', function(location) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        element.click(function() {
          location.path(element.children().attr('id'));
          element.toggleClass('active');
        });
      }
    };
  }]);
