Spree::Variant.class_eval do
  self.whitelisted_ransackable_associations = %w[option_values product_name prices default_price]
end