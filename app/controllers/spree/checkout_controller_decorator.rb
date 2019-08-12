module Spree
  CheckoutController.class_eval do
    def update
      if @order.payment? && params[:order][:payments_attributes].present? && Spree::PaymentMethod.find(params[:order][:payments_attributes][0]['payment_method_id']).type == "Spree::Gateway::Yandex"
        redirect_to(yandex_checkout) && return
      end
      if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
        @order.temporary_address = !params[:save_user_address]
        unless @order.next
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to(checkout_state_path(@order.state)) && return
        end

        if @order.completed?
          @current_order = nil
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          Spree::AdminOrderMailer.admin_email(@order).deliver_later
          redirect_to completion_route && return
        else
          redirect_to checkout_state_path(@order.state)
        end
      else
        render :edit
      end
    end

    def yandex_checkout
      items = @order.line_items.map(&method(:line_item))
      shipping_adjustments = @order.all_adjustments.shipping
      payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes][0]['payment_method_id'])
      return unless payment_method.type == "Spree::Gateway::Yandex"
      shipping_adjustments.each do |adjustment|
        next if adjustment.amount.zero?
        items << {
            description: adjustment.label,
            quantity: "1.00",
            amount: {
                currency: item.order.currency,
                value: '%.2f'%adjustment.amount
            },
            payment_subject: "commodity",
            vat_code: "1",
            payment_mode: "full_prepayment"
        }
      end
      idempotence_key = SecureRandom.uuid
      url = "https://payment.yandex.net/api/v3/payments"
      uri = URI(url)
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req['Accept'] = "application/json"
      req['Idempotence-Key'] = idempotence_key
      req.basic_auth payment_method.preferred_shop_id, payment_method.preferred_api_key
      req.body = yandex_data(@order, items).to_json
      result = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(req)
      end
      json_result = JSON.parse(result.body)
      if result.code == '200'
        if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env) && @order.next
          Spree::AdminOrderMailer.admin_email(@order).deliver_later if @order.completed?
          payment = @order.payments.first
          yandex = Spree::YandexCheckout.create(idempotence_key: idempotence_key, confirmation_url: json_result['confirmation']['confirmation_url'], refundable: json_result['refundable'], yandex_id: json_result['id'], status: json_result['status'], payment_id: payment.id)
          payment.started_processing
          json_result['confirmation']['confirmation_url']
        else
          flash[:error] = @order.errors.full_messages.join("\n")
          checkout_state_path(@order.state)
        end
      else
        flash[:error] = Spree.t('yandex.connection_error')
        checkout_state_path(@order.state)
      end
    end


    private

    def line_item(item)
      {
          description: item.product.name,
          product_code: item.variant.sku,
          quantity: '%.2f'%item.quantity,
          amount: {
              currency: item.order.currency,
              value: '%.2f'%(item.price+item.adjustments.promotion.sum(:amount)/item.quantity)
          },
          payment_subject: "commodity",
          vat_code: "1",
          payment_mode: "full_prepayment"
      }
    end
    def yandex_data(order, items)
      {
          amount:
              {
                  value: '%.2f'%order.total,
                  currency: order.currency
              },
          capture: true,
          description: Spree.t(:order)+" "+order.number,
          confirmation:
              {
                  type: "redirect",
                  return_url: order_url(order)
              },
          receipt:
              {
                  customer:
                      {
                          full_name: order.name,
                          email: order.email,
                          phone: order.ship_address.phone
                      },
                  items: items
              }
      }
    end
  end
end