module Spree
  class ErrorsController < StoreController

    layout 'spree/layouts/errors'
    def show
      @status = status_code.to_s
      render :status => status_code
    end

    protected

    def status_code
      params[:code] || 500
    end
  end
end
