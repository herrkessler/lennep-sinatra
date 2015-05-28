$(document).ready(function() {
  initialFavs();
});

function initialFavs() {
  if ($.cookie('favourites') === undefined) {
    $.cookie('favourites', '', { expires: 2, path: '/' });
  }

  var favCounter = $('.favourite-counter'),
      cookieCounter = ($.cookie('favourites').split(/,/).length),
      sessionUserStatus = $('body').hasClass('logged-in'),
      controlFavs = $.cookie('favourites').split(/,/);

  if (sessionUserStatus) {
    // Do nothing ;-)
  } else {

    if (controlFavs[0] !== "") {
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
      cookieCounter = ($.cookie('favourites').split(/,/).length),
      sessionUserStatus = $('body').hasClass('logged-in'),
      initialCount = parseInt(favCounter.text()),
      controlFavs = $.cookie('favourites').split(/,/);

  favCounter.addClass('add');
  setTimeout(function(){
    favCounter.removeClass('add');
  }, 300);

  if (sessionUserStatus) {
    if (type == "add") {
      favCounter.addClass('active');
      if (isNaN(initialCount)) {
        favCounter.text("1");
      } else {
        favCounter.text(initialCount + 1);
      }
    }

    if (type == "remove" && initialCount > 0) {
      favCounter.text(initialCount - 1);
    } 

    if (type == "remove" && initialCount == 1) {
      favCounter.text("");
      favCounter.removeClass('active');
    }
  } else {
    if (type == "add") {
      favCounter.text(cookieCounter);
      favCounter.addClass('active');
    }

    if (type == "remove") {
      if (controlFavs[0] !== "") {
        favCounter.text(cookieCounter);
      } else {
        favCounter.text('');
        favCounter.removeClass('active');
      }
    }
  }
}
