module Spree
  class AdminOrderMailer < BaseMailer
    def admin_email(order)
      I18n.locale = :ru
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      subject = "Новый заказ №#{@order.number}"
      to = "order@rus-souvenirs.com"
      mail(to: to, from: from_address, subject: subject)
    end
  end
end