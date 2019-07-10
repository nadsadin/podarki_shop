Deface::Override.new(
    :virtual_path   => "spree/admin/products/_form",
    :name           => "is_hit_to_admin_product",
    :insert_bottom  => "[data-hook='admin_product_form_promotionable']",
    :text           => "
      <div>
        <%= f.field_container :is_hit, class: ['form-group'] do %>
          <%= f.label :is_hit, Spree.t(:is_hit) %>
          <%= f.error_message_on :is_hit %>
          <%= f.check_box :is_hit, class: 'form-control' %>
        <% end %>
      </div>
"
)