class Spree::Slide < ActiveRecord::Base
  has_one_attached :image
  acts_as_list
end
