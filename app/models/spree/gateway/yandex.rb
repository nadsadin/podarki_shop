class Spree::Gateway::Yandex < Spree::Gateway
  preference :shop_id, :string
  preference :api_key, :string

  def provider_class
    Spree::Gateway::Yandex
  end

  def method_type
    'yandex'
  end


  def source_required?
    false
  end

  def purchase(amount, transaction_details, options = {})
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end
end