module Spree
  class OneclickMailer < BaseMailer
    def admin_email(oneclick)
      @name = oneclick.name
      @phone = oneclick.phone
      @product = oneclick.product
      subject = "Новый заказ в один клик"
      to = Spree::Config.oneclick_email_to || from_address
      mail(to: to, from: from_address, subject: subject)
    end
  end
end