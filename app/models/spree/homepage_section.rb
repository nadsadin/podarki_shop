class Spree::HomepageSection < ApplicationRecord
  belongs_to :taxon
  has_one_attached :image
  acts_as_list

  def min_price=(value)
    super(value.present? ? value : ('%.0f' % Spree::Price.where(variant: Spree::Variant.where(product: self.taxon.products.available).ids).minimum(:amount)))
  end
end
