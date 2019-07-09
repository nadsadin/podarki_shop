class Spree::Admin::ImportsController < Spree::Admin::BaseController
  def index

  end
  def create
    @import = Spree::Import.new(import_params)
    @import.set_import_xml
    @import.set_offers_xml
    @import.set_offers
    @import.update_taxons
    @import.update_products
    if @import.errors.present?
      render 'index'
    else
      flash[:success] = "Импорт завершен успешно"
      redirect_to admin_imports_path
    end
  end

  def import_params
    params.require(:import).permit(:zip_file)
  end
end