//= require spree/api/storefront/cart
//= require spree/frontend/cart


Spree.ready(function () {
  var addToCartForm = document.getElementById('add-to-cart-form')
  var addToCartButton = document.getElementById('add-to-cart-button')

  if (addToCartForm) {
    // enable add to cart button
    if (addToCartButton) {
      addToCartButton.removeAttribute('disabled')
    }

    addToCartForm.addEventListener('submit', function (event) {
      event.preventDefault()

      // prevent multiple clicks
      if (addToCartButton) {
        addToCartButton.setAttribute('disabled', 'disabled')
      }

      var variantId = addToCartForm.elements.namedItem('variant_id').value
      var quantity = parseInt(addToCartForm.elements.namedItem('quantity').value, 10)

      // we need to ensure that we have an existing cart we want to add the item to
      // if we have already a cart assigned to this guest / user this won't create
      // another one
      Spree.ensureCart(
        function () {
          SpreeAPI.Storefront.addToCart(
            variantId,
            quantity,
            {}, // options hash - you can pass additional parameters here, your backend
            // needs to be aware of those, see API docs:
            // https://github.com/spree/spree/blob/master/api/docs/v2/storefront/index.yaml#L42
            function () {
              // redirect with `variant_id` is crucial for analytics tracking
              // provided by `spree_analytics_trackers` extension
              Spree.url_params["variant_id"] = variantId.toString();
              window.location = Spree.pathFor('cart')
            },
            function (error) { alert(error) } // failure callback for 422 and 50x errors
          )
        }
      )
    })
  }
})