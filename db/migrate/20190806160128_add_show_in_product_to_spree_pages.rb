class AddShowInProductToSpreePages < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_pages, :show_in_product, :boolean
  end
end
