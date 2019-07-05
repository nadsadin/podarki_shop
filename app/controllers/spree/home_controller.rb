module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
      @latest_products = @searcher.retrieve_products.order('available_on DESC').limit(9)
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
  end
end