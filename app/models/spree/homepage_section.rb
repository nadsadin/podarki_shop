class Spree::HomepageSection < ApplicationRecord
  before_validation :set_min_price
  belongs_to :taxon
  has_one_attached :image
  acts_as_list

  def set_min_price
    self.min_price = ('%.0f' % Spree::Price.where(variant: Spree::Variant.where(product: self.taxon.products.available).ids).minimum(:amount)) unless self.min_price.present?
  end
end
