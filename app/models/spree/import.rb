require 'zip'
class Spree::Import
  include ActiveModel::Model
  attr_accessor :zip_file, :import_xml, :offers_xml, :offers

  def zip_file=(value)
    @zip_file = Zip::File.open(value.tempfile)
  end
  def set_import_xml
    @import_xml = Nokogiri::XML(@zip_file.entries.select{|entry| entry.name =~ /import.*xml/}.first.get_input_stream.read)
  end
  def set_offers_xml
    @offers_xml = Nokogiri::XML(@zip_file.entries.select{|entry| entry.name =~ /offers.*xml/}.first.get_input_stream.read)
  end
  def set_offers
    @offers = {}
    @offers_xml.css('Предложение').each do |offer_tag|
      @offers[offer_tag.at_css('Ид').children.to_s] = {
            sku: offer_tag.at_css('Артикул').children.to_s,
            price: offer_tag.at_css('Цена').at_css('ЦенаЗаЕдиницу').children.to_s,
            currency: offer_tag.at_css('Цена').at_css('Валюта').children.to_s,
            qty: offer_tag.at_css('Количество').children.to_s,
          }
    end
  end

  def get_image(file_name)
    @zip_file.entries.select{|entry| entry.name =~ /#{file_name}/}.first.get_input_stream.read
  end

  def update_taxons
    groups = import_xml.at_css('Группа').css('Группа')
    groups.each do |group|
      id_1c = group.at_css('Ид').children.to_s
      name = group.at_css('Наименование').children.to_s
      taxonomy = Spree::Taxonomy.where(name: name).first_or_initialize
      unless taxonomy.id_1c == id_1c
        taxonomy.id_1c = id_1c
        taxonomy.save
        taxonomy.errors.full_messages.each{|m| self.errors.add(:taxonomy, m)}
        taxon = Spree::Taxon.where(name: name).first_or_initialize
        unless taxon.id_1c == taxonomy.id_1c
          taxon.id_1c = taxonomy.id_1c
          taxon.taxonomy_id = taxonomy.id
          taxon.save
          taxon.errors.full_messages.each{|m| self.errors.add(:taxon, m)}
        end
      end
    end
  end

  def update_products
    products_tag = @import_xml.css('Товар')
    products_tag.each do |product_tag|
      id_1c = product_tag.at_css('Ид').children.to_s
      taxon_id_1c = product_tag.at_css('Группы').css('Ид').map{|e| e.children.to_s}
      product = Spree::Product.where(id_1c: id_1c).first_or_initialize
      product.shipping_category ||= Spree::ShippingCategory.first
      product.available_on ||= Date.current
      params = {
          sku: product_tag.at_css('Артикул').children.to_s,
          name: product_tag.at_css('Наименование').children.to_s,
          taxon_ids: Spree::Taxon.where(id_1c: taxon_id_1c).ids,
          description: product_tag.at_css('Описание').children.to_s.gsub!(/\n/, '</p><p>'),
          price: offers[id_1c][:price],
          cost_currency: offers[id_1c][:currency],
      }
      product.assign_attributes(params)
      product.save
      if product.errors.present?
        product.errors.full_messages.each{|m| self.errors.add(:products, m)}
      else
        update_product_images(product, product_tag.css('Картинка'))
        product.master.stock_items.first.update(count_on_hand: offers[id_1c][:qty].to_i) unless product.master.stock_items.first.count_on_hand == offers[id_1c][:qty].to_i
      end
    end
  end

  def update_product_images(product, image_tags)
    image_tags.each do |image_tag|
      image_name = image_tag.children.to_s
      filename = File.basename(image_name)
      unless product.images.any?{|i| image_name =~ /#{i.attachment.filename.to_s}/}
        image = product.images.build
        tempfile = Tempfile.new(filename)
        tempfile.binmode
        tempfile.write get_image(image_name)
        tempfile.rewind
        image.attachment.attach(io: tempfile, filename: filename)
        image.save
        image.errors.full_messages.each{|m| self.errors.add(:images, m)}
      end
    end
  end
end
