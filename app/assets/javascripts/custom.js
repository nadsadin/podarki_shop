(function(win, doc, $) {
  $(function() {
    var mySwiper = new Swiper ('#main-slider', {
      // Optional parameters
      pagination: {
        el: '.swiper-pagination',
        clickable: true
      },
      autoplay: {
        delay: 5000,
      },
    });
  });
})(window, document, jQuery);