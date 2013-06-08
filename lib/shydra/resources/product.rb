module Shydra
  module Resources
    class Product < Shydra::Request
      def initialize(*args)
        args.unshift(:product)
        super(*args)
      end      
    end
  end
end
