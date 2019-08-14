class AddLinkToSpreeSlideTranslations < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Spree::Slide.add_translation_fields! link: :string
      end

      dir.down do
        remove_column :spree_slide_translations, :link
      end
    end
  end
end
