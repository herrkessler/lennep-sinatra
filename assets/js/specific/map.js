var view = window.location.href;
var geojson = [];

function getUrlParameter(sParam) {
  var sPageURL = window.location.search.substring(1);
  var sURLVariables = sPageURL.split('&');
  if (sParam === undefined) {
    if (sURLVariables[0] === '') {
      return '';
    } else {
      return '?' + sURLVariables[0];
    }
  } else {
    for (var i = 0; i < sURLVariables.length; i++) {
      var sParameterName = sURLVariables[i].split('=');
      if (sParameterName[0] == sParam) {
        return sParameterName[1];
      }
    }
  }
}

function getMap(data) {
  var venues = data;

  $.each(venues, function(index, venue) {
    geojson.push(
      {
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [venue.location.lng, venue.location.lat]
        },
        "properties": {
          "title": venue.title,
          "description": venue.street + '<br/>' + venue.zip + ' ' + venue.town,
          "marker-color": venue.categories[0].colour,
          'marker-symbol': venue.categories[0].icon,
          "marker-size": "large",
          "url": '/venues/' + venue.id,
          "image": venue.mainImage,
          "city": venue.town,
        }
      }
    );
  });

  L.mapbox.accessToken = 'pk.eyJ1IjoiaGVycmtlc3NsZXIiLCJhIjoiRGU5R0JVYyJ9.jrfMyYYLrHEQEeWircmkGA';

  var map = L.mapbox.map('map', 'herrkessler.k8e97o6c')
    .setView(["51.192641", "7.257206"], 17);

  var myLayer = L.mapbox.featureLayer().addTo(map);
  var whereAmI = L.mapbox.featureLayer().addTo(map);

  myLayer.setGeoJSON(geojson);

  myLayer.on('mouseover', function(e) {
    e.layer.openPopup();
  });
  myLayer.on('mouseout', function(e) {
    e.layer.closePopup();
  });
  myLayer.on('click', function(e) {
    e.layer.unbindPopup();
    var url = window.location.href;
    window.location.assign(e.layer.feature.properties.url);
  });
  var geolocate =           $('.js-find-on-map'),
      geolocateWrapper =    $('#gelocation-wrapper'),
      selectedCategory =    $('.category-list-item a'),
      resetAllFilter =      $('.js-reset-filter-button');

  // Functions

  resetAllFilter.click(function() {
    myLayer.setFilter(function(f) {
      selectedCategory.removeClass('highlight reversed');
      resetAllFilter.removeClass('active');
      return true;
    });
    return false;
  });

  if (!navigator.geolocation) {
    geolocate.innerHTML = 'Geolocation is not available';
  } else {
    geolocate.click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      map.locate();
    });
  }

  map.on('locationfound', function(e) {
    map.fitBounds(e.bounds);

    whereAmI.setGeoJSON({
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [e.latlng.lng, e.latlng.lat]
      },
      properties: {
        'title': 'Hier bin ich!',
        'marker-color': '#2980B9',
        'marker-symbol': 'pitch',
        'marker-size': 'large'
      }
    });

    whereAmI.eachLayer(function(m) {
        m.openPopup();
      });
  });

  selectedCategory.on('click', function(event) {
    resetAllFilter.addClass('active');
    event.preventDefault();
    var cName = $(this).data('id');
    $(this).addClass('highlight reversed').closest('.category-list-item').siblings().find('a').removeClass('highlight reversed');
    myLayer.setFilter(function(f) {
      return f.properties['marker-symbol'] === cName;
    });
    return false;
  });

  // map.on('locationerror', function() {
  //   geolocate.innerHTML = 'Ich bin unauffindbar...';
  //   geolocateWrapper.show();
  //   geolocate.show();
  //   geolocateWrapper.className = 'error';
  //   loader.hide();
  //   error.show();
  //   error.className = 'pulse';
  //   setTimeout(function() {
  //     error.className = 'fadeOut';
  //   }, 2000);
  // });

  // geolocateClose.click(function(e) {
  //   geolocateWrapper.hide();
  //   return false;
  // });
}

// Map for /venues

$.ajax({
  url: "/venues-map" + getUrlParameter(),
  dataType: 'json',
  contentType: 'application/json',
  type: 'GET',
  accepts: "application/json",
  success: function(data) {
    getMap(data);
  }, 
  error: function(data) {
    console.log(data);
  }
});

