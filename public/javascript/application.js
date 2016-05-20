// $(document).ready(function() {
//   $(function() {
//     $('date-picker').daterangepicker({
//         singleDatePicker: true,
//         showDropdowns: true
//     }, 
//     function(start, end, label) {});
//     });
//   $(function() {
//     $('date-picker').daterangepicker({
//         singleDatePicker: true,
//         showDropdowns: true
//     }, 
//     function(start, end, label) {});
//     });
// });
 
$(document).ready(function() {
    $('input[name="daterange"]').daterangepicker({
        timePicker: true,
        timePickerIncrement: 1,
        locale: {
            format: 'MM/DD/YYYY h:mm A'
        }
    });
});
