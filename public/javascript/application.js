$(document).ready(function() {
    $('input[name="daterange"]').daterangepicker({
        timePicker: true,
        timePickerIncrement: 1,
        locale: {
            format: 'YYYY/MM/DD HH:mm',
            use24hours: true
        }
    });
    $('.selectpicker').selectpicker({
      style: 'btn-info',
      size: 4
  });
});

