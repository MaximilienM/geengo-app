$(document).ready(function() {
  
  $("body.sign_in input[name='employee[email]']").blur(function() {
    email = $(this).val();
    $.ajax({
      url: "valid_email",
      data: {id: email},
      dataType: "script"
    });
    
  });
  
});