module Spree
  class YandexController < Spree::StoreController
    skip_before_action :verify_authenticity_token
    def check_payment
      json_result = JSON.parse(request.body.read)
      if json_result['event'].include?('payment')
        payment_request = json_result['object']
        yandex = Spree::YandexCheckout.where(yandex_id: payment_request['id']).first
        payment = yandex.payment if yandex.present?
        payment_method = Spree::PaymentMethod.find(payment.payment_method_id) if payment.present?
        Raven.extra_context(
                 json_result: json_result,
                 payment_request: payment_request,
                 yandex: yandex,
                 payment: payment,
                 payment_method: payment_method
        )
        render(status: 500)&&return unless yandex.present? && payment.present? && payment_method.present?
        url = "https://payment.yandex.net/api/v3/payments/#{payment_request['id']}"
        uri = URI(url)
        req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
        req['Accept'] = "application/json"
        req.basic_auth payment_method.preferred_shop_id, payment_method.preferred_api_key
        result = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
          http.request(req)
        end
        payment_result = JSON.parse(result.body)
        if payment_result['status'] == payment_request['status']
          if payment_result['status'] == 'waiting_for_capture'
            payment.started_processing unless payment.processing?
          elsif payment_result['status'] == 'succeeded'
            payment.started_processing
            payment.complete
          elsif payment_result['status'] == 'canceled'
            payment.started_processing
            payment.failure
          end
        end
      end
      respond_to do |format|
        format.json {render :json => {msg: 'OK'}.to_json}
      end
    end
  end
end