document.addEventListener("turbolinks:load", function() {

  /* Radio button click */
  const radio_group = document.querySelectorAll(".radio-group .radio");

  [].forEach.call(radio_group, el => {
    el.addEventListener('click', radioClick, false)
  })

  function radioClick() {
    [].forEach.call(radio_group, el => {
      if (el !== this) el.classList.remove('active');
    });

    this.classList.toggle('active');

    let selected = this.dataset.value;
    let radio_value = document.getElementById("radio_value");
    let edit_btn = document.getElementById("edit_btn");
    if(edit_btn){
      //let old_value = edit_btn.getAttribute("data-path");
      let path = selected;
      //console.log("old: ",old_value);
      edit_btn.href = path;
    }
    radio_value.value = selected;
  }
  /* End of Radio click */



  const investment_field = document.getElementById("investment_wizard_invested_amount");
  const investment_value = document.getElementById("expected_return");
  const cb = document.querySelector("#continueButton");
  var inv_attr = window.investment_attributes;
  console.log('inv attr', inv_attr);
  if(inv_attr) {
    var investment_escaped = $.parseHTML(inv_attr)[0].textContent
  }
  $(investment_field).on('keyup', function(e) {
    if($(this).val().length > 1) {
      var ev = this;
      console.log("key up", ev.value);
      window.amount = ev.value; //.toFixed(2);

      let cButton = document.querySelector("#continueButton");
      if(cButton.hasAttribute('disabled')) {
        cButton.removeAttribute('disabled');
      }

      var new_attr = investment_escaped.replace(/\[invested_amount\]\=\d*/, '[invested_amount]=' + ev.value);

      // Call for expected returned
      // Expected return is calculated via model ExpectedReturn
      $.ajax({
        url: '/expected_return_25',
        type: 'POST',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        data: new_attr,
        success: function(response) {
          $('#expected_return').text(window.cur_sign + parseFloat(response).toFixed(2));
          //console.log("success", response);
        }
      });
      $.ajax({
        url: '/currency_converter',
        type: "GET",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        data: {"currency": window.currency, "amount": ev.value },
        success: function(response) {
          let cr = document.getElementById("crypto_rate");
          $(cr).children('option').remove();
          $.each(response, function(key, value) {
            $(cr).append('<option value="'+key+'">' + key + ' ' + value +'</option>');
          });
        }
      });
    } // end if key.leygth > 1
  });

  const timeframe_field = document.getElementById("investment_wizard_timeframe");
  const timeframe_value = document.getElementById("timeframe_value");
  if(timeframe_value && timeframe_value) {
    $("#bSlider").on('slide', function(ev) {
      alert(ev);
      //timeframe_field.value = ev.value;
      //timeframe_value.innerHTML = ev.value + " Months";
    });
  }


  /* Modal window if amount not in range of investment plan */
  /*
  const modalWindow = document.getElementById("changePlan");
  const plans = {basic:1000,blue:10000,vip:50000}
  const form = document.querySelector("#new_investment_wizard");
  const continueButton = document.querySelector("#continueButton");

  if(window.invPlan && continueButton) {
    continueButton.addEventListener("click", function(event) {
      event.preventDefault();
      let max = eval('plans.'+ window.invPlan.toLowerCase());
      let min = 50;
      let keys = Object.keys( plans );
      for(var i = 0; i < Object.keys(plans).length; i++) {
        if(keys[i] === window.invPlan.toLowerCase()) {
          min = i - 1;
        }
      }
      min = plans[Object.keys(plans)[min]]
      // If amount less than min OR amount more than max
      if(window.amount <= min || window.amount >= max) {
        $(modalWindow).modal('show');
        // disable button
        continueButton.setAttribute("disabled", true);
      }else{
        form.submit();
      }
    });
  }
  */
  /* Modal window if amount not in range */

  /* Paybear Payments */
  var payBtn = document.getElementById("pay_paybear");
  if(payBtn) {
    payBtn.addEventListener("click", function(event) {
      let investment_id = window.investment;
      //console.log( parseInt(investment_id) );

      (function () {
        window.paybear = new Paybear({
          settingsUrl: `/payments?investment=` + parseInt(investment_id)
        });
      })();
    });
  }
  /* End of PayBear Payments */

});

/* Invested Amount Range Slider */
function invested_amount(value) {
  let expected_amount = value * 1.50;
  const expected = document.getElementById("expected_return");
  const invested_amount = document.getElementById("investment_wizard_invested_amount");
  expected.innerHTML = value * 1.50;
  invested_amount.value = value;
}
