Deface::Override.new(
    :virtual_path   => "spree/admin/products/_form",
    :name           => "is_handmade_to_admin_product",
    :insert_bottom  => "[data-hook='admin_product_form_promotionable']",
    :text           => "
      <div>
        <%= f.field_container :is_handmade, class: ['form-group'] do %>
          <%= f.label :is_handmade, Spree.t(:is_handmade) %>
          <%= f.error_message_on :is_handmade %>
          <%= f.check_box :is_handmade, class: 'form-control' %>
        <% end %>
      </div>
"
)