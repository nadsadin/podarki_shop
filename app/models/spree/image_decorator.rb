module YourApplication
  module Spree
    module ImageDecorator
      module ClassMethods
        def styles
          {
              mini:    '48x48>',
              small:   '100x100>',
              product: '240x240>',
              large:   '2000x2000>',
          }
        end
      end

      def self.prepended(base)
        base.inheritance_column = nil
        base.singleton_class.prepend ClassMethods
      end
    end
  end
end

Spree::Image.prepend ::YourApplication::Spree::ImageDecorator