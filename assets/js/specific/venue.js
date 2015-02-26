$(document).ready(function(){
  var listToggleButton = $('.js-toggle-map-view'),
      mapWrapper = $('#map-wrapper'),
      venueWrapper = $('#venue-wrapper');

  listToggleButton.on('click', function(event){
    event.preventDefault();
    if ($(this).hasClass('active')) {
      $(this).removeClass('active').find('.fa-map-marker').addClass('fa-list').removeClass('fa-map-marker');
      mapWrapper.removeClass('active');
      venueWrapper.removeClass('active');
    } else {
      $(this).addClass('active').find('.fa-list').removeClass('fa-list').addClass('fa-map-marker');
      mapWrapper.addClass('active');
      venueWrapper.addClass('active');
    }
  });
});