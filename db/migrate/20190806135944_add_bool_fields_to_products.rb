class AddBoolFieldsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :is_new, :boolean
    add_column :spree_products, :is_handmade, :boolean
  end
end
