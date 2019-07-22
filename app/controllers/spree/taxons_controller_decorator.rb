module Spree
  TaxonsController.class_eval do
    helper_method :sorting_param

    def show
      @taxon = Taxon.friendly.find(params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
      @products = @searcher.retrieve_products.reorder('').send(sorting_scope)
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end


    def sorting_param
      params[:sorting].try(:to_sym) || default_sorting
    end

    private

    def sorting_scope
      allowed_sortings.include?(sorting_param) ? sorting_param : default_sorting
    end

    def default_sorting
      :ascend_by_master_price
    end

    def allowed_sortings
      [:descend_by_master_price, :ascend_by_master_price, :descend_by_avg_rating, :ascend_by_translated_name, :descend_by_popularity]
    end
  end
end