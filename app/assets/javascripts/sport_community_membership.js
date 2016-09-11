$(document).ready(function() {
  $('.scm-name').click(function() {
    $(this).next(".scm-infos").toggle();
  })
  
  $('#destroy-scm-modal .btn.secondary').click(function() {
    $('#destroy-scm-modal').modal('hide');
    return false;
  });
  
});