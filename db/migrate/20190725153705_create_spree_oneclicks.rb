class CreateSpreeOneclicks < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_oneclicks do |t|
      t.string :name
      t.string :phone
      t.integer :product_id

      t.timestamps
    end
  end
end
