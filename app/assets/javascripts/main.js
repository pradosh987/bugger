// Main javascript file for angular

var bugger = angular.module("bugger", []);

bugger.controller("interfaceController", function($scope) {

  $("form.bugger-file-uploader").submit(function() {
    // var formData = new FormData($(this)[0]);
    // $.post($(this).attr("action"), formData, function() {
    //     // success 
    //     console.log("form data uploaded");   
    // });
    // return false;


    return true;
  });


  $scope.bugger_job_progress = 10;

  $scope.bugger_job_count = 100;

  $scope.is_processing = true;


  function show_main_spinner() {
    console.log("trigger spinner");
  }

  function hide_spinner() {
    console.log("hide spinner");
  }


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
  

});