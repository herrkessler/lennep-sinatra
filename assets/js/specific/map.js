$(document).ready(function(){

  var view = window.location.href;
  var geojson = [];

  function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    if (sParam === undefined) {
      if (sURLVariables[0] === '') {
        return '';
      } else {
        return '?'+sURLVariables[0];
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
    var sessionUser = {};

    sessionUser.lat = '51.1925939';
    sessionUser.lng = '7.2582474';
    geojson.push(
      {
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [sessionUser.lng,sessionUser.lat]
        },
        "properties": {
          "title": "Hello you there",
          "description": "Unbekannter Besucher",
          "marker-color": "#354B60",
          'marker-symbol': 'pitch',
          "marker-size": "large",
          "url": '#'
        }
      }
    );

    $.each(venues, function(index, venue){
      geojson.push(
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [venue.location.lng,venue.location.lat]
          },
          "properties": {
            "title": venue.title,
            "description": venue.street +'<br/>'+venue.zip+' '+venue.town,
            "marker-color": venue.categories[0].colour,
            'marker-symbol': venue.categories[0].icon,
            "marker-size": "large",
            "url": '/venues/' + venue.id,
            "image" : venue.mainImage,
            "city": venue.town,
          }
        }
      );
    });

    L.mapbox.accessToken = 'pk.eyJ1IjoiaGVycmtlc3NsZXIiLCJhIjoiRGU5R0JVYyJ9.jrfMyYYLrHEQEeWircmkGA';

    var map = L.mapbox.map('map', 'herrkessler.k8e97o6c')
      .setView([sessionUser.lat, sessionUser.lng], 17);

    var myLayer = L.mapbox.featureLayer().addTo(map);

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
});
