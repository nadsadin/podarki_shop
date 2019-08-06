Spree::PromotionAction.class_eval do
  protected

  def label
    promotion.name
  end
end