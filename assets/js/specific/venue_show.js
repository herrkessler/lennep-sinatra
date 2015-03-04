$(document).ready(function(){
  var faveButton = $('.js-venue-faved-button'),
      venueID = $('#venue-profile').data('id').toString(),
      favesList = $.cookie('favourites').split(/,/),
      modal = $('#modal-wrapper'),
      continueButton = $('#continue');

  console.log(venueID, favesList);

  if ($.inArray(venueID,favesList) != -1) {
    faveButton.addClass('faved').text('Aus meinen Favouriten entfernen');
  } else {
    faveButton.removeClass('faved');
  }

  faveButton.on('click', function(event) {
    event.preventDefault();

    var venueList = $.cookie('favourites').split(/,/);
    console.log(venueList);

    if ($.cookie('favourites') !== "") {

      if ($(this).hasClass('faved')) {
        venueList = jQuery.grep(venueList, function(value) {
          return value != venueID;
        });
        $.cookie('favourites', venueList, { path: '/' });
        $(this).removeClass('faved').text('Zu meinen Favouriten hinzufügen');
      }
      else {
        venueList.push(venueID);
        $.cookie('favourites', venueList, { path: '/' });
        $(this).addClass('faved').text('Aus meinen Favouriten entfernen');
      }

    } else {
      modal.addClass('active');
      $.cookie('favourites', venueID, { path: '/' });
      $(this).addClass('faved').text('Aus meinen Favouriten entfernen');
    }
  });

  continueButton.on('click', function(event){
    event.preventDefault();
    modal.removeClass('active');
  });
  
});