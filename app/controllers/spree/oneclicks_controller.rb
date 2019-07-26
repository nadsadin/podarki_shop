module Spree
  class OneclicksController < Spree::StoreController
    helper 'spree/products'
    respond_to :js

    def create
      @oneclick = Spree::Oneclick.new(oneclick_params)
      Spree::OneclickMailer.admin_email(@oneclick).deliver_later if @oneclick.save
    end

    private

    def oneclick_params
      params.require(:oneclick).permit(:name, :phone, :product_id)
    end
  end
end