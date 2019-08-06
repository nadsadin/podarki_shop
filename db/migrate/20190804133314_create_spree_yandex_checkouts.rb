class CreateSpreeYandexCheckouts < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_yandex_checkouts do |t|
      t.string :idempotence_key
      t.string :confirmation_url
      t.string :refundable
      t.string :yandex_id
      t.string :status
      t.integer :payment_id

      t.timestamps
    end
  end
end
