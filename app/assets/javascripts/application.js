// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage
//= require jquery3
//= require jquery_ujs
//= require turbolinks
//= require popper
//= require bootstrap
//= require moment
// require Chart.min
//= require Chart.bundle.min
//= require bootstrap-slider
//= require bootstrap-datepicker
//= require expected_return
//= require paybear
//= require datatables.min
//= require payments
//= require wizard_investment
//= require intlTelInput
//= require libphonenumber/utils
//= require social-share-button
//= require isotope.pkgd.min
//= require select/jquery.selectric.min
//= require profile
//= require ion.rangeSlider/ion.rangeSlider.min
//= require investments
//= require dashboard
//= require wizard/ion.rangeSlider/ion.rangeSlider.js


document.addEventListener("turbolinks:load", function() {
  if($('[class^=dataTables_length]').length == 0) {
    $('#data').DataTable();
  }
});


