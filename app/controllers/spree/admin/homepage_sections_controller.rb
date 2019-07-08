module Spree
  module Admin
    class HomepageSectionsController < ResourceController
      respond_to :html

      def index
        @homepage_sections = Spree::HomepageSection.order(:position)
      end

      private

      def location_after_save
        if @homepage_section.created_at == @homepage_section.updated_at
          edit_admin_homepage_section_url(@homepage_section)
        else
          admin_homepage_sections_url
        end
      end

      def homepage_section_params
        params.require(:homepage_section).permit(:title, :description, :link, :image, :position)
      end
    end
  end
end