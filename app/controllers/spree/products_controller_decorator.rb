module Spree
  ProductsController.class_eval do
    helper_method :sorting_param

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products.reorder('').send(sorting_scope)
      @taxonomies = Spree::Taxonomy.includes(root: :children)
      @locale = locale
    end


    def sorting_param
      params[:sorting].try(:to_sym) || default_sorting
    end

    private

    def sorting_scope
      allowed_sortings.include?(sorting_param) ? sorting_param : default_sorting
    end

    def default_sorting
      :descend_by_master_price
    end

    def allowed_sortings
      [:descend_by_master_price, :ascend_by_master_price,  :descend_by_avg_rating, :ascend_by_translated_name, :descend_by_popularity]
    end
  end
end