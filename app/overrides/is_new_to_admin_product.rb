Deface::Override.new(
    :virtual_path   => "spree/admin/products/_form",
    :name           => "is_new_to_admin_product",
    :insert_bottom  => "[data-hook='admin_product_form_promotionable']",
    :text           => "
      <div>
        <%= f.field_container :is_new, class: ['form-group'] do %>
          <%= f.label :is_new, Spree.t(:is_new) %>
          <%= f.error_message_on :is_new %>
          <%= f.check_box :is_new, class: 'form-control' %>
        <% end %>
      </div>
"
)