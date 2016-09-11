# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.Application ||= {}

bar = ->
  
  $.each Gmaps.map.markers, (index, marker) ->
    google.maps.event.addListener marker.serviceObject, 'mouseover', ->
      console.log "over  marker"
        
window.Application.bar = bar