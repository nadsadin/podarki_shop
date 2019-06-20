(function(win, doc, $) {
  doc.addEventListener('turbolinks:load', function() {

    var mySwiper = new Swiper ('#main-slider', {
      // Optional parameters
      pagination: {
        el: '.swiper-pagination',
        clickable: true
      },
    })
  });
})(window, document, jQuery);