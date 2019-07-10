module Spree
  StoreController.class_eval do

    def render_404
      render :status => status_code
    end


    protected

    def status_code
      params[:code] || 500
    end
  end
end