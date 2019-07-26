class Spree::Slide < ActiveRecord::Base
  has_one_attached :image
  acts_as_list
  translates :title
  include SpreeGlobalize::Translatable
end
