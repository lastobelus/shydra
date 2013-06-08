module Shydra
  module Resources
    class Metafield < Shydra::Resource
      has_parents :product, :variant, :blog, :custom_collection, :order, :page, :customer
    end
  end
end
