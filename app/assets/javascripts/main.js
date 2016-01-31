// Main javascript file for angular

var bugger = angular.module("bugger", []);

bugger.controller("interfaceController", function($scope) {  

});

bugger.controller("resultController", ["$scope", "$interval","$q", "$http", function($scope, $interval, $q, $http ) {

  // $scope.results = [
  //   {
  //     title: "A product title goes here",
  //     product_ref: "TSHEFE99ZCGDK5ZJ",
  //     main_image: "http://btesimages.s3.amazonaws.com/Wolfpack/wp_dontpassthebuck_orange_1.jpg",
  //     passed: false,
  //     errors: [
  //       {
  //         field: "A Feidl title",
  //         expected: "An expected data",
  //         actual: "Actual data found"
  //       }
  //     ]
  //   },
  //   {
  //     title: "A product title goes here",
  //     product_ref: "TSHEFE99ZCGDK5ZJ",
  //     main_image: "http://btesimages.s3.amazonaws.com/Wolfpack/wp_dontpassthebuck_orange_1.jpg",
  //     passed: true,
  //     errors: [
  //       {
  //         field: "A Feidl title",
  //         expected: "An expected data",
  //         actual: "Actual data found"
  //       }
  //     ]
  //   },
  //   {
  //     title: "A product title goes here",
  //     product_ref: "TSHEFE99ZCGDK5ZJ",
  //     main_image: "http://btesimages.s3.amazonaws.com/Wolfpack/wp_dontpassthebuck_orange_1.jpg",
  //     passed: false,
  //     errors: [
  //       {
  //         field: "A Feidl title",
  //         expected: "An expected data",
  //         actual: "Actual data found"
  //       }
  //     ]
  //   }
  // ]

  $scope.bugger_job_progress = 0;

  $scope.bugger_job_count = "counting...";

  $scope.is_processing = true;

  $scope.all_passed = false;

  var polling_url = "/poll?id="

  var errors = [
    {
      key: "A Feidl title",
      type: "Mismatch"
    },
    {
      key: "A Feidl title",
      type: "Missing",
      expected_value: "An expected data",
      actual_value: "Actual data found"
    },
    {
      key: "A Feidl title",
      type: "Mismatch"
    },
    {
      key: "A Feidl title",
      type: "Missing",
      expected_value: "An expected data",
      actual_value: "Actual data found"
    }
  ]


  deferred = $q.defer();

  $scope.poll_id = $("#bugger_job_id").val();

  var poll_prom = $interval(function() {
    $http.get("/bugger_jobs/" + $scope.poll_id + "/get_poll_results")
    .success(function(data) {
      update_data(data.bugger_job);
    });
  }, 5000, 40);

  function update_data(data){
    console.log(data);
    $scope.results = data.results.reverse();

    if(data.state == "completed"){
      is_processing = false;
      stop_poll();
      stop_spinner();

      $(".progress-headline").text("File successfully processed.")
    } else {

    }
  
    // Injecting results
    if($scope.results.length > 0) {
      $scope.results[0]["errors"] = errors;
      if($scope.results.length > 6) {
      $scope.results[5]["errors"] = errors;
      }
    }

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