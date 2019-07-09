class Add1cidsToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :id_1c, :string
    add_column :spree_taxons, :id_1c, :string
    add_column :spree_taxonomies, :id_1c, :string
  end
end
