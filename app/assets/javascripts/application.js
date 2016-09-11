// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.bxSlider.min
//= require jquery.purr
//= require best_in_place
//= require bootstrap
//= require gmaps4rails/googlemaps.js
//= require_tree .

$(document).ready(function() {
  $('.dropdown').dropdown();
  $('.pills').pills();
  $('.alert-message').alert();
  
  $("[rel='twipsy']").twipsy({placement: "below"});
  $('.has-popover').popover({content: popoverContent, html: "true"});
  
  $('#left-events').bxSlider({
    auto: true,
    pager: true,
    pagerLocation: "top",
    pagerSelector: "#left-events-pager",
    controls: false,
    speed: 1500,
    pause: 6000
  });
  
  $('#featured-events').bxSlider({
    auto: true,
    pager: true,
    pagerLocation: "top",
    pagerSelector: "#featured-events-pager",
    controls: false,
    speed: 1500,
    pause: 6000
  });
  
  $(".best_in_place").best_in_place();
  
});

function popoverContent () {
  return $(this).find('.popover-content').html();
}

// var _ues = {
// host:'geengo.userecho.com',
// forum:'9922',
// lang:'fr',
// tab_corner_radius:10,
// tab_font_size:20,
// tab_image_hash:'Vm90cmUgYXZpcw%3D%3D',
// tab_alignment:'right',
// tab_text_color:'#FFFFFF',
// tab_bg_color:'#808080',
// tab_hover_color:'#F45C5C'
// };
// 
// (function() {
//     var _ue = document.createElement('script'); _ue.type = 'text/javascript'; _ue.async = true;
//     _ue.src = ('https:' == document.location.protocol ? 'https://s3.amazonaws.com/' : 'http://') + 'cdn.userecho.com/js/widget-1.4.gz.js';
//     var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(_ue, s);
//   })();


var uvOptions = {};
 (function() {
   var uv = document.createElement('script'); uv.type = 'text/javascript'; uv.async = true;
   uv.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'widget.uservoice.com/EqYP4Sp5FG5szzSUpjm3g.js';
   var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(uv, s);
 })();