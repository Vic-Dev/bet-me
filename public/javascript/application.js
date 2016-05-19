$(document).ready(function() {
  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
  $("#proof_form").sumbit(function(){
    $("#proof_image").show();
    return true;
  });
});
