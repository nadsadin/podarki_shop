class AddTranslationsToSlides < ActiveRecord::Migration[5.2]
  def up
    unless table_exists?(:spree_slide_translations)
      params = {title: :string}
      Spree::Slide.create_translation_table!(params, { migrate_data: true })
    end
  end
  def down
    Spree::Slide.drop_translation_table! migrate_data: true
  end
end
