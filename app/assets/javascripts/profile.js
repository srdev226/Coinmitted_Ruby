document.addEventListener("turbolinks:load", function() {

  const add_phone_btn = document.getElementById("add_phone_number");
  const enable_wallet_pin = document.getElementById("enable_wallet_pin");
  //const verify_number = document.querySelectorAll("#verify_number");

  if(add_phone_btn) {
    add_phone_btn.addEventListener("click", function(event) {
      let phone_number_block = document.getElementById("phone_number_block");
      phone_number_block.style.display = phone_number_block.style.display === 'none' ? '' : 'none';
    });
  }

  if(enable_wallet_pin) {
    enable_wallet_pin.addEventListener("click", function(event) {
      event.preventDefault();
      let profile_wallet_pin = document.getElementById('profile_wallet_pin');
      let wallet_pin_block = document.getElementById("wallet_pin_block");
      wallet_pin_block.style.display = 'block';
      enable_wallet_pin.disabled = true;
    });
  }

  // fill content of modal
  const phone_number = document.getElementById("");

  // Internation Phone plugin
  var protocol = location.protocol;
  var slashes = protocol.concat("//");
  var port = location.port;
  var host = slashes.concat(window.location.hostname);

  const add_num_btn = $("#button-addon2");
  const telInput = $(".phone"),
  errorMsg = $("#error-msg"),
  validMsg = $("#valid-msg");

  telInput.intlTelInput({
      formatOnInit: true,
      separateDialCode: true,
      hiddenInput: "full_phone",
      initialCountry: "auto",
      geoIpLookup: function(callback) {
        $.get('https://ipinfo.io', function() {}, "jsonp").always(function(resp) {
          var countryCode = (resp && resp.country) ? resp.country : "";
          callback(countryCode);
        });
      },
    //utilsScript: host + (port ? ':'+port : '') + "/assets/libphonenumber/utils.js"
  });

  var reset = function() {
    telInput.removeClass("error");
    errorMsg.addClass("hide");
    validMsg.addClass("hide");
  };

  // on blur: validate
  add_num_btn.on('click', function(e) {
  //telInput.blur(function() {
    reset();
    if ($.trim(telInput.val())) {
      if (telInput.intlTelInput("isValidNumber")) {
        validMsg.removeClass("hide");
      } else {
        e.preventDefault();
        telInput.addClass("error");
        errorMsg.removeClass("hide");
      }
    }
  });

  // on keyup / change flag: reset
  telInput.on("keyup change", reset);
  $('.authenticator-enable-button').click(function(){
    console.log('test');
  })
});


/* Ajax call to resend OTP */
function resendOTP(loader_url){
  $("#resend_otp").on('click', function(){
    $("#flash_messages").html("<img src="+loader_url+" style='margin-bottom:20px; line-height: 17px;'>");
    $.ajax({
        url: "/profile/resend_otp",
        type: "GET",
        dataType : "script",
        data: {},
        success: function () {
        },
        error: function(xhr, status, error) { /*Handled browser generated error. Incomplete Ajax*/ }
    });
  });
}
