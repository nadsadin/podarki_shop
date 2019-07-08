class CreateSpreeHomepageSections < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_homepage_sections do |t|
      t.integer :taxon_id
      t.string :min_price
      t.integer :position, :null => false, :default => 0

      t.timestamps
    end
  end
end
