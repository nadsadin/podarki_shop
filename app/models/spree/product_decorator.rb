Spree::Product.class_eval do
  has_many :reviews

  scope :ascend_by_translated_name, -> {order('spree_product_translations.name'=> :asc)}
  scope :descend_by_avg_rating, -> {order(avg_rating: :desc)}

  def stars
    avg_rating.try(:round) || 0
  end

  def rating
    '%.1f' % avg_rating || "0.0"
  end
end