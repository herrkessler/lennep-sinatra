$(document).ready(function() {
  var listToggleButton = $('.js-toggle-map-view'),
      mapWrapper = $('#map-wrapper'),
      venueWrapper = $('#venue-wrapper'),
      mapLink = $('#map-link'),
      mapHeight = mapWrapper.outerHeight(),
      venueCard = $('.venue'),
      favouriteButton = $('.card-favourite-indicator'),
      sessionUserId = $('body').data('id'),
      sessionUserStatus = $('body').hasClass('logged-in'),
      initialCookie = $.cookie('favs'),
      modal = $('#modal-wrapper'),
      continueButton = $('#continue');

  listToggleButton.on('click', function(event) {
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

  $(window).scroll(function() {
    var windowPosition = $(window).scrollTop();

    if (windowPosition > mapHeight) {
      mapLink.addClass('active');
    }

    if (windowPosition < mapHeight) {
      mapLink.removeClass('active');
    }
  });

  if (sessionUserStatus) {

    favouriteButton.on('click', function(event) {
      var selectedVenue = $(this).closest('.venue').data('id');
      if ($(this).hasClass('faved')) {
        $(this).removeClass('faved');
        updateFavs("remove");
        $.get('/venues/' + selectedVenue + '/delete/' + sessionUserId, function() {
        });
      } else {
        $(this).addClass('faved');
        updateFavs("add");
        $.get('/venues/' + selectedVenue + '/add/' + sessionUserId, function() {
        });
      }
    });
    
  } else {
    if ($.cookie('favourites') === undefined) {
      $.cookie('favourites', '', { expires: 2, path: '/' });
    } else {
      var venueList = $.cookie('favourites').split(/,/);
      $('.card').each(function() {
        if ($.inArray($(this).attr('data-id'), venueList) != -1) {
          $(this).find('.card-favourite-indicator').addClass('faved');
        }
      });
    }

    favouriteButton.on('click', function(event) {
      event.preventDefault();

      var venueID = $(this).closest('.card').data('id') ;
      var venueList = $.cookie('favourites').split(/,/);

      if (venueList[0] === "") {
        venueList = [];
      }

      if ($.cookie('favourites') !== "") {

        if ($(this).hasClass('faved')) {
          venueList = jQuery.grep(venueList, function(value) {
            return value != venueID;
          });
          $.cookie('favourites', venueList, { path: '/' });
          $(this).removeClass('faved');
          updateFavs("remove");
        }
        else {
          venueList.push(venueID);
          $.cookie('favourites', venueList, { path: '/' });
          $(this).addClass('faved');
          updateFavs("add");
        }

      } else {
        modal.addClass('active');
        venueList.push(venueID);
        $.cookie('favourites', venueList, { path: '/' });
        $(this).addClass('faved');
        updateFavs("add");
      }
    });
  }

  continueButton.on('click', function(event) {
    event.preventDefault();
    modal.removeClass('active');
  });

});
