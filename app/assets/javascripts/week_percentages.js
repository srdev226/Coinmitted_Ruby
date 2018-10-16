document.addEventListener("turbolinks:load", function() {

  const date_field = document.getElementById("weeklyDatePicker");
  const cal_value = document.getElementById("cal_value");
  var new_val;
  $("#weeklyDatePicker").datepicker({
    weekStart: 1,
    calendarWeeks: true,
    useCurrent: false,
    autoclose: true,
    lang: 'en'
  }).on('changeDate', function (e) {
      var value = $("#weeklyDatePicker").val();
      var firstDate = moment(e.date, "YYYY-MM-DD").day(1).format('YYYY-MM-DD');
      var lastDate =  moment(e.date, "YYYY-MM-DD").day(7).format('YYYY-MM-DD');
      //var firstDate = moment(value, "MM-DD-YYYY").day(0).format("MM-DD-YYYY");
      //var lastDate =  moment(value, "MM-DD-YYYY").day(6).format("MM-DD-YYYY");
      new_val = firstDate + " - " + lastDate;
      console.log("new val", new_val);

      //$("#weeklyDatePicker").val(new_val);
      date_field.value = new_val;
  }).on('hide', function(){
      date_field.value = new_val;
      cal_value.value = new_val;
  });


});
