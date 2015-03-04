$(document).ready(function(){
  initialFavs();
});

function initialFavs() {
  if ($.cookie('favourites') === undefined){
    $.cookie('favourites', '', { expires: 2, path: '/' });
  }

  var favCounter = $('.favourite-counter'),
      cookieCounter = ($.cookie('favourites').split(/,/).length)-1,
      sessionUserStatus = $('body').hasClass('logged-in');

  if (sessionUserStatus) {
  } else {

    if (cookieCounter > 0) {
      favCounter.text(cookieCounter);
      favCounter.addClass('active');
    } else {
      favCounter.text('');
      favCounter.removeClass('active');
    }
  }
}

function updateFavs(type) {
  var favCounter = $('.favourite-counter'),
      cookieCounter = ($.cookie('favourites').split(/,/).length)-1,
      sessionUserStatus = $('body').hasClass('logged-in'),
      initialCount = parseInt(favCounter.text());

  if (sessionUserStatus) {
    if (type == "add") {
      favCounter.text(initialCount+1);
    }
    if (type == "remove" && initialCount > 0) {
      favCounter.text(initialCount-1);
    }
  } else {
    if (type == "add") {
      favCounter.text(cookieCounter);
      favCounter.addClass('active');
    }
    if (type == "remove") {
      if (cookieCounter > 0) {
        favCounter.text(cookieCounter);
      } else {
        favCounter.text('');
        favCounter.removeClass('active');
      }
    }
  }
}
