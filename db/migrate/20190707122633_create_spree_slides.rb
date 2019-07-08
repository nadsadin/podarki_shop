class CreateSpreeSlides < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_slides do |t|
      t.string :link
      t.string :title
      t.string :description
      t.integer :position, :null => false, :default => 0

      t.timestamps
    end
  end
end
