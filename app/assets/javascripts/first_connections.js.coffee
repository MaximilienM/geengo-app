# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  
  $('.select-community').change ->
    sc_id = $(this).attr("data-community-id")
    $("#new-scm-for-sc-" + sc_id).toggle "drop"