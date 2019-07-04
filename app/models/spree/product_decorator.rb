Spree::Product.class_eval do
  has_many :reviews

  def stars
    avg_rating.try(:round) || 0
  end

  def rating
    '%.1f' % avg_rating || "0.0"
  end
end