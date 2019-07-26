class Spree::Oneclick < ApplicationRecord
  belongs_to :product
  validates_presence_of :name, :phone
end
