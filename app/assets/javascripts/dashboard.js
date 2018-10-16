// js Document



(function($) {
    "use strict";
    //$(document).on ('ready', function (){
    document.addEventListener("turbolinks:load", function() {
        var name = "";
        var plan_id = 1;
        var months = 3;
        var open_date, end_date;
        var frequency_id = 1;
        var invested_amount = 50.00;
        var user_id = window.cur_user_id;
        var frame = $(".range-time");
        var min_amount = 50;
        var max_amount = 999;
        var method_name = "none";
        var payment_method_id = 1;
        var earning = 0;
        var expected_return = 0;
        var cur_step = "start-invest-tab";
        var stat = 1;
        var cur_id = -1;
        var edit_id;
        var first_name;
        $('.edit-invest-button').click(function(){
          edit_id = $(this).val();
          $.ajax({
            url: '/investment/get_edit_investment',
            type: 'POST',
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: "id=" + edit_id,
            success: function(response) {
              var investment = response.investment;
              name = investment.name;
              plan_id = investment.investment_plan_id;
              months = investment.timeframe;
              $.ajax({
                url: "/investment/get_status",
                type: "POST",
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data: "stat=" + investment.status,
                success: function(data) {
                  stat = data.status;
                }
              });  
              open_date = investment.open_date;
              end_date = investment.end_date;
              frequency_id = investment.payout_frequency_id;
              invested_amount = investment.invested_amount;
              user_id = investment.user_id;
              payment_method_id = investment.payment_method_id
              earning = investment.investment_earning;
              expected_return = investment.expected_return;
              cur_id = investment.id;
              $('.prev_invested').html(invested_amount);  
              $('.new_invested').html(invested_amount);
              $('.usd-return-' + edit_id).html(window.cur_sign + expected_return);
              $('.edit-invest-name').val(name);
              $.ajax({
                url: "/investment/get_frequency",
                type: "POST",
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data: "payout_freq_id=" + frequency_id,
                success: function(data) {
                  $('.edit-payout-ddown-' + edit_id +' option[value=' + data.name + ']').prop('selected', true);
                }
              });  
            }
          });
          $('.edit-invest-name').on('keyup', function(){
            name = $(this).val();
          })
          $('.continue-step1').click(function(event){
            event.preventDefault();
            var payout_index = $('.edit-payout-ddown-' + edit_id).prop('selectedIndex'); 
            $.ajax({
              url: "/investment/get_frequency",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "freq_id=" + payout_index,
              success: function(data) {
                frequency_id = data.payout_frequency.id;
              }
            });  
            cryptocurrency_amount_edit(window.currency, invested_amount, edit_id);
            $('.modal-navs > li .active').parent('li').next('li').find('a').trigger('click');
          })
          $(".invested-amount-" + edit_id).on('change', function(){
            invested_amount = $(".invested-amount-" + edit_id).val();
            $('.new_invested').html(invested_amount);
            $.ajax({
              url: '/expected_return',
              type: 'POST',
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "investment[name]=" + name +
                "&investment[invested_plan_id]=" + plan_id +
                "&investment[invested_amount]=" + invested_amount +
                "&investment[open_date]=" + open_date + 
                "&investment[end_date]=" + end_date + 
                "&investment[payout_frequency_id]=" + frequency_id + 
                "&investment[timeframe]=" + months + 
                "&investment[user_id]=" + user_id,
              success: function(response) {
                expected_return = parseFloat(Number(invested_amount) + Number(response)).toFixed(2);
                earning = parseFloat(response).toFixed(2);
                $('.usd-return-' + edit_id).html(window.cur_sign + expected_return);
              }
            });
            cryptocurrency_amount_edit(window.currency, invested_amount, edit_id);
          })
          $(".timeframe-input-" + edit_id).on('change', function(){
            var months = $('.timeframe-input-' + edit_id + ' option:selected').val();
            $.ajax({
              url: "/investment/get_end_date",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "months=" + months,
              success: function(data) {
                open_date = data.open_date;
                end_date = data.end_date;
                $(".end-date-" + edit_id).val("Investment End Date: " + dateformat(data.end_date));
              }
            });
          })
          $(".confirm-button").on('click', function(){
            console.log(stat);
             $.ajax({
              url: "/investment/confirm",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data:"name=" + name +
              "&invested_amount=" + invested_amount +
              "&open_date=" + open_date + 
              "&end_date=" + end_date + 
              "&user_id=" + user_id + 
              "&invested_plan_id=" + plan_id +
              "&payout_frequency_id=" + frequency_id + 
              "&payment_method_id=" + payment_method_id +
              "&timeframe=" + months + 
              "&expected_return=" + expected_return + 
              "&investment_earning=" + earning +
              "&currency=" + window.currency +
              "&status=" + stat +
              "&id=" + cur_id,
              success: function(data) {
                location.reload();
              }
            });          
          })
          $('.crypto_rate-' + edit_id).on('change', function(e){
            console.log(e);
            $('.cryptocurrency-amount-' + edit_id).html($(".crypto_rate-" + edit_id + " option:selected").val());
          }) 
        })
        $('.close-edit-modal').click(function(){
          location.reload();
        })
                // --------------------- SVG convert Function
        $('img.svg').each(function(){
        var $img = $(this);
        var imgID = $img.attr('id');
        var imgClass = $img.attr('class');
        var imgURL = $img.attr('src');
    
        $.get(imgURL, function(data) {
            // Get the SVG tag, ignore the rest
            var $svg = $(data).find('svg');
    
            // Add replaced image's ID to the new SVG
            if(typeof imgID !== 'undefined') {
                $svg = $svg.attr('id', imgID);
            }
            // Add replaced image's classes to the new SVG
            if(typeof imgClass !== 'undefined') {
                $svg = $svg.attr('class', imgClass+' replaced-svg');
            }
    
            // Remove any invalid XML tags as per http://validator.w3.org
            $svg = $svg.removeAttr('xmlns:a');
            
            // Check if the viewport is set, else we gonna set it if we can.
            if(!$svg.attr('viewBox') && $svg.attr('height') && $svg.attr('width')) {
                $svg.attr('viewBox', '0 0 ' + $svg.attr('height') + ' ' + $svg.attr('width'))
            }
    
            // Replace image with new SVG
            $img.replaceWith($svg);
    
            }, 'xml');

        });
        // Mobile menu
        if ($('.close-aside-menu').length) {
          $('.close-aside-menu,.dropdown-overlay').on('click', function () {
            $('.dashboard-sidebar-navigation').removeClass("show-menu");
            $(".dropdown-overlay").removeClass("active");
          });
        };
        if ($('.toggle-show-menu-button').length) {
          $('.toggle-show-menu-button').on('click', function () {
            $('.dashboard-sidebar-navigation').addClass("show-menu");
            $(".dropdown-overlay").addClass("active");
          });
        };


        // -------------------- Remove Placeholder When Focus Or Click
        $("input,textarea").each( function(){
            $(this).data('holder',$(this).attr('placeholder'));
            $(this).on('focusin', function() {
                $(this).attr('placeholder','');
            });
            $(this).on('focusout', function() {
                $(this).attr('placeholder',$(this).data('holder'));
            });
        });

        // --------------------- ToolTip
        $('[data-toggle="tooltip"]').tooltip()


        // ----------------------- Dropdown Overlay
        $ ("#main-top-header .dropdown-toggle").on('click', function(){
            $("body").addClass("Overlay-active");
            $(".dropdown-overlay").addClass("active");
        })
        $('.dropdown-overlay,.dropdown-menu').click(function() {
          $('.dropdown-overlay').removeClass('active');
        })

        // ----------------------- Select js
        $('.theme-select-dropdown').selectric();
        const status = $('#status_form');
        status.change(function() {
            status.submit();
        });
        $('.select-dropdown').on('change', function(){
            var ind = document.getElementById("wdrop_down").selectedIndex;
            ind = Number(ind);
            

            // document.getElementById("month-data").innerHTML = "<%(0...@weeks).each {|i| if @total_weeks[i].first_date.month == @weekly_ddownlist_m["+ind+"]%><li class='week-data clearfix'><div class='week-frame font-fix'><%='#{@months[i]} #{@total_weeks[i].first_date.day} - #{@months[i]} #{@total_weeks[i].last_date.day}'%></div><div class='profit-return'><%='#{@total_weeks[i].percentage}'%>%</div></li><%else @a = 1 end}%>"
                // $("#month-data").html("<%(0...10).each {|i| %><li class='week-data clearfix'><div class='week-frame font-fix'>July 30 - August 5</div><div class='profit-return'><%=i%></div></li><%else @a = 1 end}%>");
            var len = $('#wdrop_down').children('option').length;
            if (ind == len - 1){
              for (var i = 0; i< len; i ++)
                $("#month-data-"+i).show();
            }
            else{
              for (var i = 0; i< len; i ++)
                $("#month-data-"+i).hide();
              $("#month-data-"+ind).show();
            }
            
            return false;
        });
        // ---------------------- Popup Page Changer
        $('.send-number-button').click(function(){
            var country_code = document.getElementById("countries-input-0").value;
            var phone_number = document.getElementById("phone").value;
            $.ajax({
              url: "/profile/send_phone_verification",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "phone_number=" + phone_number + "&country_code=" + country_code,
              success: function(data) {
                document.getElementById("phone-number").innerHTML = phone_number;
                $('.modal-navs > li .active').parent('li').next('li').find('a').trigger('click');
              }
            });
            return false;
        });
        $('.resend-button').click(function(){
            var country_code = document.getElementById("countries-input-0").value;
            var phone_number = document.getElementById("phone").value;
            $.ajax({
              url: "/profile/send_phone_verification",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "phone_number=" + phone_number + "&country_code=" + country_code,
              success: function(data) {
              }
            });
            return false;
        });
        $('.verify-button').click(function(){
            var country_code = document.getElementById("countries-input-0").value;
            var phone_number = document.getElementById("phone").value;
            var code = document.getElementById("phone-verification-code").value;
            $.ajax({
              url: "/profile/verify_phone",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "phone_number=" + phone_number + "&country_code=" + country_code + "&code=" + code,
              success: function(data) {
                $('#success-tab').trigger('click');
              }
            });
            return false;
        });
        $('.success-button').click(function(){
            $('#add-number-tab').trigger('click');
            $('#phone').val("");
            $('#countries-input-0').val("+1");
            $('#phone-verification-code').val("");
            $('#mobile-verification').modal('hide');
            $("#phone-number-section").html();
        });
        $('.continue-button').click(function(){
            $('.modal-navs > li .active').parent('li').next('li').find('a').trigger('click');
        });
        $('.back-button').click(function(){
            $('.modal-navs > li .active').parent('li').prev('li').find('a').trigger('click');
        });

        $('.continue-button-two').click(function(){
            $('.modal-navs-two > li .active').parent('li').next('li').find('a').trigger('click');
        });
        $('.back-button-two').click(function(){
            $('.modal-navs-two > li .active').parent('li').prev('li').find('a').trigger('click');
        });

        // ------------------- Telephone Number Delete
        $(".number-delete-button").on("click", function() {
            $(this).parent(".single-number-input").hide(100);
        });

        // ------------------- Country Select Dropdown
        //$("#country").countrySelect();
        // -------------------- Phone Number Select Dropdown
        //$("#phone").intlTelInput({
          //utilsScript: "vendor/intl-tel/build/js/utils.js"
        //});

        // ----------------------------- Time Frame Slider
        // Moved to investments.js

        // ------------------- Run AJAX call
        // /* TODO */ --- Refactor later ---
        const runConversationForWallet = function() {
          let wallet_deposit_field = document.getElementById("wallet_deposit_field");
          let ticker;
          let selected_crypto = document.querySelector('input[name=pay-check]:checked');

          if( selected_crypto) {
            ticker = getTicker(selected_crypto.getAttribute('id'));
          }else {
            ticker = '';
          }

          $.ajax({
            url: '/currency_in_crypto',
            type: "GET",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            data: {"currency": window.currency, "amount": wallet_deposit_field.value, "ticker": ticker },
            success: function(response) {
              document.getElementById('input_deposit_crypto_field').value = response.data;
              document.getElementById('deposit_crypto_field').innerHTML = ticker.toUpperCase();
              document.getElementById('deposit_fiat_btn').innerHTML = window.currency + ' ' + wallet_deposit_field.value;
              ['btc','eth','ltc'].forEach(function(item){
                document.getElementById('deposit_'+item).style.display = 'none';
              });
              document.getElementById('deposit_'+ticker).style.display = 'block';
              document.getElementById('side_deposit_fiat').innerHTML = window.currency + ' ' + wallet_deposit_field.value;
              document.getElementById('side_deposit_crypto').innerHTML = response.data + ' ' + ticker.toUpperCase();
          console.log('success', response);
            }
          });
        };
        const runConversationForInvestment = function() {
        };
        /* Wallet Radio button click */
        var $radios = $('input[type="radio"][name="pay-check"]')
        const wallet_payment_method = document.querySelector(".wallet-payment-method");
        if($radios && wallet_payment_method) {
          $('input[type="radio"]').click(function() {
            var $checked = $radios.filter(':checked');
            var $next = $radios.eq($radios.index($checked));
            $next.prop("checked", true);
            // run func on change
            runConversationForWallet();
          });
        }
        /* End of Wallet Radio click */

      // -------------------- Wallet Deposit Calculations
      const wallet_deposit_field = document.getElementById("wallet_deposit_field");
      if(wallet_deposit_field) {
        //console.log(wallet_deposit_field);
        $(wallet_deposit_field).on('keyup', function(e) {
          let ev = this;

          delay(function(){
            runConversation();
          }, 800 );
        });
      }

      // Delay function for keyup
      var delay = (function(){
        var timer = 0;
        return function(callback, ms){
          clearTimeout (timer);
          timer = setTimeout(callback, ms);
        };
      })();

      // ------------------ Get Ticker from name
      const getTicker = function(data) {
        let tickers = {"pay-bitcoin":"btc","pay-ethereum":"eth","pay-litecoin":"ltc"}
        return tickers[data];
      }



        // ------------------- Custom Checkbox

        $('input.cur-check').on('select', function() {
            $('input.cur-check').not(this).prop('checked', false);  
        });

        // -------------------- Currnecy Dropdown List
        $(".select-currnecy-list").click(function(e) {
            e.preventDefault();
            var content = $(this).html();
            $('.selected-currency').replaceWith('<div class="balance-sheet-wrapper selected-currency">' + content + '</div>');
          });
        //----------------------Actions in create investment
        $('.new-invest-button').on('click', function(){
          var edit_step = "none";
          if(frame.length){
              frame.ionRangeSlider({
                min: 1,
                max: 12,
                from: 3
              });  
          }
          $('.new-invest-button').click(function(){
            $.ajax({
              url: "/investment/get_end_date",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "months=" + 3,
              success: function(data) {
                open_date = data.open_date;
                end_date = data.end_date;
                $(".investment-month").html(3 + " Months");
                $(".invest-end-date").html("Investment End Date: " + dateformat(data.end_date));
              }
            });
          })
  
          $('.amount-continue').prop('disabled', true);
          $('.invest-name-condition').hide();
          $('.invest-plan-condition').hide();
          $('.invest-amount-condition').hide();
          $('.invest-payout-condition').hide();
          $('.invest-payment-condition').hide();
          $('.invest-edit-condition').hide();
  
          $(".investment-name").on('keyup', function(e){
              if ($(".investment-name").val().length > 0){
                $('.invest-name-condition').hide();
              }
              else{
                $('.invest-name-condition').show();
              }
          })
          $('.start-button').click(function(){
              goto_next_step();
          })
          $('.name_continue_button').click(function(){
              name = $(".investment-name").val();
              if (name.length == 0){
                $('.invest-name-condition').show();
                return;
              }
              $('.invest_name').html($(".investment-name").val());
              goto_next_step();
          });
          $('.plan-continue-button').click(function(){
              plan_id = $('.plan-list > li > div > input:checked').val();
              if (!plan_id){
                $('.invest-plan-condition').show();
                return;
              }
              $.ajax({
                url: '/investment/get_range',
                type: 'POST',
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data: 'plan_id=' + plan_id,
                success: function(response) {
                  min_amount = parseFloat(response.min).toFixed(0);
                  max_amount = parseFloat(response.max).toFixed(0);
                  invested_amount = min_amount;
                  $('.currency_amount').val(invested_amount);
                  $('.invest-amount-condition').html('Coinmitted requires $' + min_amount + ' minimum investment and $' + max_amount + ' maximum investment');
                  $('.invest_name').html($(".investment-name").val());
                  cryptocurrency_amount(window.currency, invested_amount);
                  goto_next_step();
                }
              });
          });
          $('.timeframe-continue-button').click(function(){
              $.ajax({
                url: '/expected_return_25',
                type: 'POST',
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data: "investment[name]=" + name +
                  "&investment[invested_plan_id]=" + plan_id +
                  "&investment[invested_amount]=" + invested_amount +
                  "&investment[open_date]=" + open_date + 
                  "&investment[end_date]=" + end_date + 
                  "&investment[payout_frequency_id]=" + frequency_id + 
                  "&investment[timeframe]=" + months + 
                  "&investment[user_id]=" + user_id,
                success: function(response) {
                  //expected_return = parseFloat(Number(invested_amount) + Number(response)).toFixed(2);
                  expected_return = Number(response).toFixed(2);
                  earning = parseFloat(Number(invested_amount) - Number(response)).toFixed(2);
                  $('.expected_return').html("Expected return : " + window.cur_sign + expected_return);
                  $('.total-return-value').text(window.cur_sign + expected_return);
                  
                }
              });
              goto_next_step();
          });
          
          $('.payout-continue-button').click(function(){
              var freq = $('.payout-frequency-list > li > div > input:checked').val();
              if (!freq){
                $('.invest-payout-condition').show();
                return;
              }
              $('.invest-amount-condition').hide();
              goto_next_step();
          });
          
          $(".range-time").on('change', function(){
            months = Number($(".range-time").val());
            $(".investment-month").html(months + " Months");
            $.ajax({
              url: "/investment/get_end_date",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "months=" + months,
              success: function(data) {
                open_date = data.open_date;
                end_date = data.end_date;
                $(".invest-end-date").html("Investment End Date: " + dateformat(end_date));
              }
            });
          })
  
          $('.plan-list > li > div > input.plan-check').on('change', function() {
              $('input.plan-check').not(this).prop('checked', false);
              plan_id = $('.plan-list > li > div > input:checked').val();
              if (plan_id){
                $('.invest-plan-condition').hide();
              }
          });
  
          $('.payout-frequency-list > li > div > input.pay-check').on('change', function() {
              console.log("TEST1");
              $('input.pay-check').not(this).prop('checked', false);
              //if (!$('.plan-list > li > div > input:checked').val()){
                //console.log("TEST");
                //return;
                //}
              $('.invest-payout-condition').hide();
              var frecuency_names = ['weekly', 'tw-month', 'monthly', 'at-the-end'];
              var freq_id = frecuency_names.indexOf(this.id);
              console.log("TEST3");
              $.ajax({
                url: "/investment/get_frequency",
                type: "POST",
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                data: "freq_id=" + freq_id,
                success: function(data) {
                  console.log(data);
                  console.log("TEST");
                  frequency_id = data.payout_frequency.id;
                  $(".frequency_title").html(data.payout_frequency.title);
                  var description = data.payout_frequency.description;
                  if (data.payout_frequency.promo)
                    description = '(' + data.payout_frequency.promo + ')';
                  $(".frequency_description").html(description);
                }
              });  
          });
  
          $(".currency_amount").on('change', function(e) {
            invested_amount = parseFloat(this.value);
            if (invested_amount < min_amount || invested_amount > max_amount){
              $('.invest-amount-condition').show();
              return;
            }
            $('.invest-amount-condition').hide();
            $.ajax({
              url: '/expected_return_25',
              type: 'POST',
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "investment[name]=" + name +
                "&investment[invested_plan_id]=" + plan_id +
                "&investment[invested_amount]=" + invested_amount +
                "&investment[open_date]=" + open_date + 
                "&investment[end_date]=" + end_date + 
                "&investment[payout_frequency_id]=" + frequency_id + 
                "&investment[timeframe]=" + months + 
                "&investment[user_id]=" + user_id,
              success: function(response) {
                console.log({response});
                //expected_return = parseFloat(Number(invested_amount) + Number(response)).toFixed(2);
                expected_return = Number(response).toFixed(2);
                  earning = parseFloat(Number(invested_amount) - Number(response)).toFixed(2);
                $('.expected_return').html("Expected return : " + window.cur_sign + expected_return);
                $('.total-return-value').text(window.cur_sign + expected_return);
              }
            });
            cryptocurrency_amount(window.currency, invested_amount);
          });
          $('.crypto_rate').on('change', function(e){
            $('.cryptocurrency-amount').html($(".crypto_rate option:selected").val());
          })
          $('.amount-continue').click(function(){
              if (invested_amount < min_amount || invested_amount > max_amount)
                return;
              $('.invested-amount').html(window.cur_sign + invested_amount);
              goto_next_step();
          })
          $('.payment-method-one > li').on('click', function() {
            $('.payment-method-one > li').not(this).css({"background-color": "#fff"});
            $( this ).css({
              "background-color": "#eea",
            });
            $('.invest-payment-condition').hide();
            method_name = this.id;
          })
          $('.payment-continue-button').click(function(){
            if (method_name == "none"){
              $('.invest-payment-condition').show();
              return;
            }
            $('.invest-payment-condition').hide();
            $.ajax({
              url: "/investment/get_payment_method_id",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data: "method_name=" + method_name,
              success: function(data) {
                payment_method_id = data.method_id;
                goto_next_step();
              }
            });  
          })
          $('.final-check-list > li').on('click', function() {
            $('.final-check-list > li').not(this).find('div').css({"background-color": "#fff"});
            $( this).find('div').css({
              "background-color": "#f1f1f1",
            });
            $('.invest-edit-condition').hide();
            edit_step = $(this).attr('value');
          })
          $('.edit-button').click(function(){
            if (edit_step == "none"){
              $('.invest-edit-condition').show();
              return;
            }
            $('#' + edit_step).trigger('click');
          })
          $('.confirm-continue-button').click(function(){
            stat = 1;
            $.ajax({
              url: "/investment/confirm",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data:"name=" + name +
              "&invested_amount=" + invested_amount +
              "&open_date=" + open_date + 
              "&end_date=" + end_date + 
              "&user_id=" + user_id + 
              "&invested_plan_id=" + plan_id +
              "&payout_frequency_id=" + frequency_id + 
              "&payment_method_id=" + payment_method_id +
              "&timeframe=" + months + 
              "&expected_return=" + expected_return + 
              "&investment_earning=" + earning +
              "&currency=" + window.currency +
              "&status=" + stat +
              "&id=" + cur_id,
              success: function(data) {
                $('.read-text').html(window.cur_sign + invested_amount + " has been invested for the " + months +" month period. You can add new funds or edit your investment at any time in");
                goto_next_step();
              }
            }); 
          })
          $('.investment-finish-button').click(function(){
            location.reload();
          })
  
          $('.close').click(function(){
            cur_step = $('.modal-navs-two > li .active').parent('li').find('a');
            cur_step = cur_step[0].id;
            $('#cancel-invest-tab').trigger('click');
          })
          $('.back-button').click(function(){
            $('#' + cur_step).trigger('click');
          })
          $('.cancel-button').click(function(){
            location.reload();
          })
          $('.save-button').click(function(){
            stat = 3;
            $.ajax({
              url: "/investment/confirm",
              type: "POST",
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              data:"name=" + name +
              "&invested_amount=" + invested_amount +
              "&open_date=" + open_date + 
              "&end_date=" + end_date + 
              "&user_id=" + user_id + 
              "&invested_plan_id=" + plan_id +
              "&payout_frequency_id=" + frequency_id + 
              "&payment_method_id=" + payment_method_id +
              "&timeframe=" + months + 
              "&expected_return=" + expected_return + 
              "&investment_earning=" + earning +
              "&currency=" + window.currency +
              "&status=" + stat +
              "&id=" + cur_id,
              success: function(data) {
                location.reload();
              }
            }); 
          })  
        })
       
        /*------------------------------AmChart inserted by Urazov-----------------------------------*/
        draw_chart('monthly');
        $('.performance-nav').on('click',function(e){
          var data = e.target.id=='performance-weekly-tab'?'weekly':'monthly';
          draw_chart(data);
        })
    });

    
  $(document).ready(function(){
  })

  function zoomChart(){
      // chart.zoomToIndexes(Math.round(chart.dataProvider.length * 0.4), Math.round(chart.dataProvider.length * 0.55));
  }     

  function dateformat(date){//format Date as "day/month/year"
    var date_format = new Date(date);
    var dd = date_format.getDate();
    var mm = date_format.getMonth()+1; //January is 0!
    var yyyy = date_format.getFullYear();
    if(dd < 10){
      dd = '0'+ dd;
    }
    if(mm < 10){
      mm = '0' + mm;
    }
    return dd+'/'+mm+'/'+yyyy;
  }
  function goto_next_step(){
      $('.modal-navs-two > li .active').parent('li').next('li').find('a').trigger('click');
  }
  function cryptocurrency_amount(currency, invested_amount){
    $('.cryptocurrency-amount').html("Loading...");
    $.ajax({
      url: '/currency_converter',
      type: "GET",
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {"currency": currency, "amount": invested_amount },
      success: function(response) {
        let cr = $(".crypto_rate");
        $(cr).children('option').remove();
        $.each(response, function(key, value) {
          $(cr).append('<option value="'+value+'">' + key + '</option>');
        });
        $('.cryptocurrency-amount').html($(".crypto_rate option:selected").val());
      }
    });
  }
  function cryptocurrency_amount_edit(currency, invested_amount, edit_id){
    $('.cryptocurrency-amount-' + edit_id).html("Loading...");
    $.ajax({
      url: '/currency_converter',
      type: "GET",
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: {"currency": currency, "amount": invested_amount },
      success: function(response) {
        let cr = $(".crypto_rate-" + edit_id);
        $(cr).children('option').remove();
        $.each(response, function(key, value) {
          $(cr).append('<option value="'+value+'">' + key + '</option>');
        });
        $('.cryptocurrency-amount-' + edit_id).html($(".crypto_rate-" + edit_id + " option:selected").val());
      }
    });
  }
  function draw_chart(data){
    $.ajax({
      url: "/performance/chartdata",
      type: "POST",
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      data: "type=" + data,
      success: function(data) {
          var chart = AmCharts.makeChart("chartdiv", {
            "type": "serial",
            "theme": "light",
            "marginTop":0,
            "marginRight": 80,
            "dataProvider": data.chartdata,
            "valueAxes": [{
                "axisAlpha": 0,
                "position": "left"
            }],
            "graphs": [{
                "id":"g1",
                "balloonText": "[[category]]<br><b><span style='font-size:14px;'>[[percentage]]%</span></b>",
                "bullet": "round",
                "bulletSize": 8,
                "lineColor": "#d1655d",
                "lineThickness": 2,
                "negativeLineColor": "#637bb6",
                "type": "smoothedLine",
                "valueField": "percentage"
            }],
            "chartScrollbar": {
                "graph":"g1",
                "gridAlpha":0,
                "color":"#888888",
                "scrollbarHeight":55,
                "backgroundAlpha":0,
                "selectedBackgroundAlpha":0.1,
                "selectedBackgroundColor":"#000000",
                "graphFillAlpha":0,
                "autoGridCount":true,
                "selectedGraphFillAlpha":0,
                "graphLineAlpha":0.2,
                "graphLineColor":"#c2c2c2",
                "selectedGraphLineColor":"#000000",
                "selectedGraphLineAlpha":1

            },
            "chartCursor": {
                "categoryBalloonDateFormat": "YYYY-MM-DD",
                "cursorAlpha": 0,
                "valueLineEnabled":true,
                "valueLineBalloonEnabled":true,
                "valueLineAlpha":0.5,
                "fullWidth":true
            },
            "dataDateFormat": "YYYY-MM-DD",
            "categoryField": "last_date",
            "categoryAxis": {
                "minPeriod": "DD",
                "parseDates": true,
                "minorGridAlpha": 0.1,
                "minorGridEnabled": true
            },
            "export": {
                "enabled": true
            }
        });
        chart.addListener("rendered", zoomChart);
        if(chart.zoomChart){
          chart.zoomChart();
        }
      }
    }); 
  }
})(jQuery);
