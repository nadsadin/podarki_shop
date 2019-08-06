(function(win, doc, $) {
  $(function() {
    $('#shop-preview-slider').each(function() {
      new Swiper(this, {
        slidesPerView: 3,
        spaceBetween: 8,
        threshold: 20,
        navigation: {
          nextEl: $('#shop-preview-slider-next')[0],
          prevEl: $('#shop-preview-slider-prev')[0]
        }
      });
    });

    $('#shop-preview-slider').on('click', 'a', function(e) {
      e.preventDefault();
      $('#shop-preview-slider .border-primary').removeClass('border-primary');
      $(this).addClass('border-primary');
      $('#shop-preview-image img').attr('src', $(this).find('img').attr('src'));
    });

    $('#shop-preview-image').on('click', function(e) {
      e.preventDefault();

      // Unset focus
      $(this).blur();

      var curLink = $(this).find('img')[0].src;
      var links = [];

      $('#shop-preview-slider').find('img').each(function() {
        links.push(this.src);
      });

      window.blueimpGallery(links, {
        container: '#shop-preview-lightbox',
        carousel: false,
        hidePageScrollbars: true,
        disableScroll: true,
        index: links.indexOf(curLink)
      });
    });
  });
})(window, document, jQuery);