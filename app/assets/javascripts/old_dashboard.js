document.addEventListener("turbolinks:load", function() {

  jQuery("#currency").on('change', function(){
    let optionSelected = jQuery("option:selected", this);
    let valueSelected = this.value
    if(valueSelected !== '0') {
      jQuery(this).closest('form').submit();
    }
  });

  /* Affiliate and Campaign copy text */
  function copy_text_from_input(text) {
    const copyText = document.getElementById(text);
    if(copyText != null) {
      $("#copy-url").click(function() {
        console.log("TESTING");
        copyText.select();
        document.execCommand("copy");
        $("#success-alert").fadeTo(2000, 500).slideUp(500, function() {
          $("#success-alert").slideUp(500);
        });
      });
    }
  }

  // Copy url button affiliate and campaign
  copy_text_from_input("affiliate-url");
  copy_text_from_input("campaign-url");


  /*
  var ctx = document.getElementById("myChart").getContext('2d');
  var BarChart = new Chart(ctx, {
      type: 'bar',
      data: {
            labels: ["JAN", "FEB", "MAR", "APR", "MAY", "JUN"],
            datasets: [{
                label: 'W1',
                data: [10, 9, 3, 5, 2, 3],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                ]
            },
            {
              label: 'W2',
              data: [12, 19, 3, 5, 2, 3],
              backgroundColor: [
                  'rgba(54, 162, 235, 0.4)',
                  'rgba(54, 162, 235, 0.4)',
                  'rgba(54, 162, 235, 0.4)',
                  'rgba(54, 162, 235, 0.4)',
                  'rgba(54, 162, 235, 0.4)',
                  'rgba(54, 162, 235, 0.4)',
              ]
          },
          {
            label: 'W3',
            data: [12, 19, 3, 5, 2, 3],
            backgroundColor: [
                'rgba(54, 162, 235, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(54, 162, 235, 0.6)',
            ]
          },
          {
            label: 'W4',
            data: [12, 19, 3, 5, 2, 3],
            backgroundColor: [
                'rgba(54, 162, 235, 0.8)',
                'rgba(54, 162, 235, 0.8)',
                'rgba(54, 162, 235, 0.8)',
                'rgba(54, 162, 235, 0.8)',
                'rgba(54, 162, 235, 0.8)',
                'rgba(54, 162, 235, 0.8)',
            ]
        }]
      },
      options: {
        legend: {
          display: false
        },
        tooltips: {
          enabled: true,
          yAlign: 'above',
          mode: 'label',
          backgroundColor: '#fff',
          titleFontColor: '#777',
          bodyFontColor:  'green',
          bodySpacing: 4,
          yPadding: 9,
          displayColors: false,
          //custom: function(tooltipModel) {
            //var tooltipEl = document.getElementById('chartjs-tooltip');
            //if (!tooltipEl) {
                //tooltipEl = document.createElement('div');
                //tooltipEl.id = 'chartjs-tooltip';
                //tooltipEl.innerHTML = "<table></table>";
                //document.body.appendChild(tooltipEl);
            //}
            //function getBody(bodyItem) {
                    //return bodyItem.lines;
            //}
            //// Set Text
            //if (tooltipModel.body) {
              //var titleLines = tooltipModel.title || [];
              //var bodyLines = tooltipModel.body.map(getBody);

              //var innerHtml = '<thead>';

              //titleLines.forEach(function(title) {
                  //innerHtml += '<tr><th>' + title + ' 2018</th></tr>';
              //});
              //innerHtml += '</thead><tbody>';

              //bodyLines.forEach(function(body, i) {
                  //var colors = tooltipModel.labelColors[i];
                  //var style = 'background:' + colors.backgroundColor;
                  //style += '; border-color:' + colors.borderColor;
                  //style += '; border-width: 2px';
                  //var span = '<span style="' + style + '"></span>';
                  //innerHtml += '<tr><td>' + span + body + '</td></tr>';
              //});
              //innerHtml += '</tbody>';

              //var tableRoot = tooltipEl.querySelector('table');
              //tableRoot.innerHTML = innerHtml;
            //}
            //var position = this._chart.canvas.getBoundingClientRect();
            //tooltipEl.style.opacity = 1;
            //tooltipEl.style.position = 'absolute';
            //tooltipEl.style.left = position.left + tooltipModel.caretX + 'px';
            //tooltipEl.style.top = position.top + tooltipModel.caretY + 'px';
            //tooltipEl.style.fontFamily = tooltipModel._bodyFontFamily;
            //tooltipEl.style.fontSize = tooltipModel.bodyFontSize + 'px';
            //tooltipEl.style.fontStyle = tooltipModel._bodyFontStyle;
            //tooltipEl.style.padding = tooltipModel.yPadding + 'px ' + tooltipModel.xPadding + 'px';
          //}
        },
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero:true
            }
          }]
        }
      }
  });
  */


}); // turbolinks:load
