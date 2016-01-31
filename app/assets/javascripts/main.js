// Main javascript file for angular

var bugger = angular.module("bugger", []);

bugger.controller("interfaceController", function($scope) {


  function show_main_spinner() {
    console.log("trigger spinner");
  }

  function hide_spinner() {
    console.log("hide spinner");
  }


  
  

});

bugger.controller("resultController", ["$scope", "$interval", function($scope, $interval  ) {

  $scope.results = [
    {
      title: "A product title goes here",
      sku_id: "TSHEFE99ZCGDK5ZJ",
      image_url: "http://btesimages.s3.amazonaws.com/Wolfpack/wp_dontpassthebuck_orange_1.jpg",
      passed: false,
      errors: [
        {
          field: "A Feidl title",
          expected: "An expected data",
          actual: "Actual data found"
        }
      ]
    },
    {
      title: "A product title goes here",
      sku_id: "TSHEFE99ZCGDK5ZJ",
      image_url: "http://btesimages.s3.amazonaws.com/Wolfpack/wp_dontpassthebuck_orange_1.jpg",
      passed: true,
      errors: [
        {
          field: "A Feidl title",
          expected: "An expected data",
          actual: "Actual data found"
        }
      ]
    },
    {
      title: "A product title goes here",
      sku_id: "TSHEFE99ZCGDK5ZJ",
      image_url: "http://btesimages.s3.amazonaws.com/Wolfpack/wp_dontpassthebuck_orange_1.jpg",
      passed: false,
      errors: [
        {
          field: "A Feidl title",
          expected: "An expected data",
          actual: "Actual data found"
        }
      ]
    }
  ]

  $scope.bugger_job_progress = 0;

  $scope.bugger_job_count = "counting...";

  $scope.is_processing = true;

  var polling_url = "poll?id="


  deferred = $q.defer();

  // TODO: inject id 
  $scope.poll_id = 0;


  var poll_prom = $interval(function() {
    $http.get($scope.polling_url + $scope.poll_id)
    .success(function(data) {
      update_data(data.data);
      // if(!_.isEmpty(data.dj_poll_result) && data.dj_poll_result.state == "completed") {
      //   $scope.verifying_dns = false;
      //   $scope.dns_verified = (data.dj_poll_result.results.verified == "true" || data.dj_poll_result.results.verified == true) ? true : false;
      //   deferred.resolve(data);
      //   $scope.stop_verify_dns_poll();
      // }
    });
  }, 2000, 30);

  function update_data(data){

  }

  function complete_poll() {

    // change text

    stop_poll();
  }

  function stop_poll() {
    if (!_.isEmpty(poll_prom)) {
      $interval.cancel(poll_prom);
      poll_prom = null;
    };
  }

  function stop_spinner() {
    $scope.is_processing = false;
  }

  function start_spinner() {
    $scope.is_processing = true;
  }

}])