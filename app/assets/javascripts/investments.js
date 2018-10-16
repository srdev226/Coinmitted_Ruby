document.addEventListener("turbolinks:load", function() {

  // ----------------------------- Time Frame Slider
  var $frame= $(".range-time");
  const date_field = document.querySelectorAll("#wizard_invest_end_date");
  if($frame.length) {
    const d = new Date();
    let cur_month = d.getMonth()+1;
    date_field.forEach( function(n) {
      n.innerHTML = d.getDate()+'/'+cur_month+'/'+d.getFullYear();
    });
    $frame.ionRangeSlider({
      min: 1,
      max: 12,
      from: 1
    });
    $frame.on('change', function(e) {
      var $this = $(this),
        value = $this.prop("value");
      end_investment_date(value);
    });
  }
  const end_investment_date = function(m) {
    const d = new Date();
    let nd = new Date( d.setMonth(d.getMonth() + parseInt(m)) );
    let month = nd.getMonth() + 1;
    let new_date = nd.getDate()+'/'+month+'/'+nd.getFullYear();
    date_field.forEach(function(n) {
      n.innerHTML = new_date;
    });
  }
  /* End of Time Frame Slider */

  /* Radio Payout Frequency */
  const payout_frequency_list = document.querySelector(".payout-frequency-list");
  var $radios = $('input[type="radio"][name="payout-frequency"]');
  if( $radios && payout_frequency_list) {
    $('input[name="payout-frequency"]').click(function() {
      var $checked = $radios.filter(':checked');
      var $next = $radios.eq($radios.index($checked));
      $next.prop("checked", true);
      let payout_frequency_box = document.querySelectorAll('#payout_frequency_box');
      let payout_frequency_description_box = document.querySelectorAll('#payout_frequency_description_box');
      let selected = $(this).attr("id");
      let frequency_arr = {"weekly":"Weekly","twice":"Twice a Month","monthly":"Monthly","end_of_period":"End of Period"}
      let frequency_desc_arr = {"weekly":"Every Week","twice":"1st and the 15th","monthly":"1st business day of the month","end_of_period":""}
      document.querySelector("#payout_frequency_original_box").value = selected; // Place origianl name of frequency
      payout_frequency_box.forEach(function(n){
        n.innerHTML = frequency_arr[selected]; // Go through all frequency boxes and add new result
      });
      payout_frequency_description_box.forEach(function(n){
        n.innerHTML = frequency_desc_arr[selected];
      });
    });
  }
  /* END Radio Payout Frequency */


  /* Investment Step Amount */
  const runConversationForInvestment = function() {
    let investment_steps_amount_field = document.getElementById("investment_steps_amount_field");
    let crypto_options = document.querySelector('#investment_selected_crypto');
    //let selected_crypto = crypto_options.options[crypto_options.selectedIndex].value;
    let ticker;

    if( crypto_options ) {
      ticker = crypto_options.options[crypto_options.selectedIndex].value;
    }else {
      ticker = '';
    }

    $.ajax({
      url: '/currency_in_crypto',
      type: "GET",
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {"currency": window.currency, "amount": investment_steps_amount_field.value, "ticker": ticker },
      success: function(response) {
        document.querySelector("#converted_crypto_currency_box").innerHTML = response.data;
        document.querySelector("#investment_amount_value").value = investment_steps_amount_field.value;
        //console.log({response});
      }
    });
  };

  const runExpectedReturn = function() {
    /* Prepare investment data to calculate expected return */
    let inv_name, inv_amount, inv_open_date, inv_end_date, inv_payout_frequency, inv_payment_method, inv_timeframe, inv_expected_return, inv_currency;
    inv_name = document.querySelector("#investment_name_box").innerHTML;
    inv_amount = document.querySelector("#investment_steps_amount_field").value;
    inv_open_date = window.inv_open_date;
    inv_payout_frequency = document.querySelector("#payout_frequency_original_box").value;
    inv_timeframe = document.querySelector("#investment_timeframe_box").innerHTML;
    inv_currency = window.currency;

    let attributes = "investment[id]=&investment[name]="+ inv_name +"&investment[invested_amount]="+ inv_amount +"&investment[open_date]="+ inv_open_date +"&investment[created_at]=&investment[updated_at]=&investment[user_id]=&investment[payout_frequency_id]="+ inv_payout_frequency +"&investment[payment_method_id]="+ inv_payment_method +"&investment[timeframe]="+ inv_timeframe +"&investment[status]=draft&investment[expected_return]="+ inv_expected_return +"&investment[investment_earning]=17.5&investment[earned]=0.0&investment[currency]="+ inv_currency +"";

    $.ajax({
      url: '/expected_return_25',
      type: 'POST',
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: attributes,
      success: function(response) {
        document.querySelector("#expected_return_box").innerHTML = parseInt(response).toFixed(2);
      }
    });
  }

  const investment_steps_field = document.querySelector("#investment_steps_amount_field");
  //console.log('amount', investment_steps_field);
  if(investment_steps_field) {
    //console.log(investment_steps_field);
    $(investment_steps_field).on('keyup', function(e) {
      let ev = this;
      delay(function(){
        document.querySelectorAll("#investment_invested_amount_box").forEach(function(n) {
          n.innerHTML = parseInt(ev.value).toFixed(2);
        });
        runConversationForInvestment();
        runExpectedReturn();
      }, 800 );
    });
  }
  /* Calculate on change Crypto */
  $('#investment_selected_crypto').change(function() {
    runConversationForInvestment();
    runExpectedReturn();
  });
  /* End Calculate on change */

  // Delay function for keyup
  var delay = (function(){
    var timer = 0;
    return function(callback, ms){
      clearTimeout (timer);
      timer = setTimeout(callback, ms);
    };
  })();
  /* END Investment Step Amount */

  /* Investment Step Payment Method */

  //const payout_frequency_list = document.querySelector(".payout-method-list");
  var $radios = $('input[type="radio"][name="payment-method"]');
  if( $radios && payout_frequency_list) {
    $('input[name="payment-method"]').click(function() {
      var $checked = $radios.filter(':checked');
      var $next = $radios.eq($radios.index($checked));
      $next.prop("checked", true);

      let payment_method_value = document.querySelectorAll('#payment_method_value');
      //let payout_frequency_description_box = document.querySelectorAll('#payout_frequency_description_box');
      let selected = $(this).attr("id");
      document.querySelector("#payment_method_value").value = selected; // Place origianl name of frequency
      console.log({selected});
    });
  }
  /* END Investment Step Payment Method */

});/* End EventListener load */

/* investment steps get Investment Name */
const investmentName = function() {
  let inv_name_field = document.getElementById("investment_name");
  const investment_name_box = document.querySelectorAll('#investment_name_box');
  investment_name_box.forEach(function(n){
    n.innerHTML = inv_name_field.value;
  });
}
/* END investment steps get Investment Name */

/* investment steps get Investment Timeframe */
const investmentTimeframe = function() {
  let inv_timeframe_field = document.querySelector(".irs-single");
  const investment_timeframe_box = document.querySelectorAll('#investment_timeframe_box');
  investment_timeframe_box.forEach(function(n){
    n.innerHTML = inv_timeframe_field.innerHTML;
  });
}
/* END investment steps get Investment Timeframe */


