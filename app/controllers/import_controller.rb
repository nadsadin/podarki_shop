require 'zip'

class ImportController < ApplicationController

  skip_before_action :verify_authenticity_token

  def new
  end

  def create
    @subjects = []
    if params[:zip_file].present?
      Zip::File.open(params[:zip_file].tempfile) do |zip_file|
        zip_file.each do |entry|
          if entry.name.ends_with? 'offers0_1.xml'
            xml = Nokogiri::XML(entry.get_input_stream.read)
            xml.xpath(keys(:product)).each do |data|
              puts {
                id_1c: data.xpath(keys(:id)).first,
                vendor: data.xpath(keys(:vendor)).first,
                name: data.xpath(keys(:name)).first,
                price: data.xpath(keys(:price)).first,
              }
            end
          end
        end
      end
    end
  end

  private

  def get_data key
    @subjects.push Nokogiri::XML(file)
  end

  def create_products

  end

  def create_taxons

  end

  def keys key
    "//" + {
      id: 'ИД',
      name: 'Наименование',
      product: 'Предложение',
      vendor: 'Артикул',
      price: 'ЦенаЗаЕдиницу',
    }[key]
  end

end