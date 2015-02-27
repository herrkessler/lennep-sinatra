$(document).ready(function(){
  var listToggleButton = $('.js-toggle-map-view'),
      mapWrapper = $('#map-wrapper'),
      venueWrapper = $('#venue-wrapper'),
      mapLink = $('#map-link'),
      mapHeight = mapWrapper.outerHeight(),
      venueCard = $('.venue'),
      favouriteButton = $('.card-favourite-indicator'),
      sessionUserId = $('body').data('id');

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

  $(window).scroll(function(){
    var windowPosition = $(window).scrollTop();

    if (windowPosition > mapHeight) {
      mapLink.addClass('active');
    }
    if (windowPosition < mapHeight) {
      mapLink.removeClass('active');
    }
  });

  favouriteButton.on('click', function(event) {
    var selectedVenue = $(this).closest('.venue').data('id');
    if ($(this).hasClass('faved')) {
      $(this).removeClass('faved');
      $.get('/venues/'+selectedVenue+'/delete/'+sessionUserId, function() {
      });
    } else {
      $(this).addClass('faved');
      $.get('/venues/'+selectedVenue+'/add/'+sessionUserId, function() {
      });
    }
  });
});