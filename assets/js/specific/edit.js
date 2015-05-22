$(document).ready(function() {
  var venueCategoryButton = $('.js-set-category'),
      venueID = $('.edit-data').data('id');

  venueCategoryButton.on('click', function(event) {

    event.preventDefault();

    var venueCategorySelector = $('.venue-category:checked'),
        categoryID = venueCategorySelector.val();

    $.ajax({
      url: '/venues/' + venueID + '/addCategory/' + categoryID,
      dataType: 'json',
      contentType: 'application/json',
      type: 'GET',
      accepts: "application/json",
      success: function(data) {
        flash('Kategorie erfolgreich ausgewählt', 'success');
      }, 
      error: function(data) {
        flash('Kategorie Update fehlgeschlagen', 'error');
      }
    });
  });

});
