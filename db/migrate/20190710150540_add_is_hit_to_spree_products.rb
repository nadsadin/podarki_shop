class AddIsHitToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :is_hit, :boolean
  end
end
