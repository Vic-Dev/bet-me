var date = new Date();

$(document).ready(function() {
    function cb(start, end) {
        $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    }
    cb(moment().subtract(29, 'days'), moment());

    $('input[name="daterange"]').daterangepicker({
        timePicker: true,
        timePickerIncrement: 1,
        locale: {
            format: 'YYYY/MM/DD HH:mm',
            use24hours: true
        },
        startDate: date, 
        endDate: date,
        minDate: date
    });
    $('.selectpicker').selectpicker({
      style: 'btn-info'
  });
  var path = window.location.pathname
  var styleNavBar = function() {
    $(".nav li").each(function(){
      if ($(this).find('a').attr('href') === path) {
        $(this).addClass('active')
      };
    });
  }
  styleNavBar()
});
