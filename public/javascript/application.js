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
        startDate: new Date(), 
        endDate: new Date()
    });
    $('.selectpicker').selectpicker({
      style: 'btn-info',
      size: 4
  });
});
