Deface::Override.new(
    virtual_path: 'spree/products/show',
    name: 'add_link_to_mark_product_as_favorite',
    surround_contents: "h1[itemprop='name']",
    text: %Q{
    <%= render_original %>
    <% if spree_user_signed_in? && spree_current_user.has_favorite_product?(@product.id) %>
      <%= link_to content_tag('i','', class: 'ion ion-ios-heart').html_safe, favorite_product_path(id: @product.id, type: 'Spree::Product'), method: :delete, remote: true, class: 'favorite_link text-primary pull-right', id: 'unmark-as-favorite' %>
    <% else %>
      <%= link_to content_tag('i','', class: 'ion ion-ios-heart-empty').html_safe, favorite_products_path(id: @product.id, type: 'Spree::Product'), method: :post, remote: spree_user_signed_in?, class: 'favorite_link text-primary pull-right', id: 'mark-as-favorite' %>
    <% end %>
  }
)