module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
      @latest_products = @searcher.retrieve_products.where(is_new: true)
      @hit_products = @searcher.retrieve_products.where(is_hit: true)
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
  end
end