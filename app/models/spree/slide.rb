class Spree::Slide < ActiveRecord::Base
  has_one_attached :image
  acts_as_list
  translates :title, :link, fallbacks_for_empty_translations: true
  include SpreeGlobalize::Translatable
end
