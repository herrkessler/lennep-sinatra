$(document).ready(function(){
  var mobileNavButton = $('.js-mobile-menu-link'),
      mobileNav = $('#mobile-navigation'),
      indexLink = $('.main-navigation-list-item.index'),
      filterMapButton = $('.js-filter-map-button'),
      mapNavigation = $('#map-navigation');

  mobileNavButton.on('click', function(){
    if ($(this).hasClass('active')) {
      $(this).removeClass('active fa-times').addClass('fa-bars');
      mobileNav.removeClass('active');
      indexLink.removeClass('active');
    } else {
      $(this).addClass('active fa-times').removeClass('fa-bars');
      mobileNav.addClass('active');
      indexLink.addClass('active');
    }
  });

  filterMapButton.on('click', function(event){
    event.preventDefault();
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      mapNavigation.removeClass('active');
    } else {
      $(this).addClass('active');
      mapNavigation.addClass('active');
    }
  });
});