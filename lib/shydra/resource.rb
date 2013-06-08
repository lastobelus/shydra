module Shydra
  class Resource < Request

    class << self
      attr_reader :parents

      def has_parents(*args)
        @parents = args.map(&:to_sym)
      end

      def parent_keys
        @parent_keys ||= parents.map{|p| [p, "#{p.to_s}_id".to_sym]}.flatten.unshift(:parent_resource)
      end
    end


=begin
    parents can be specified in the following ways:

      --> assume the parent is :product
      product: 1234
      product_id: 1234
      product: {id: 1234, blah}
      product: ShopifyAPI::Product.find(1234)   #ie, a shopify object
      parent_resource: {:product => 1234}
      parent_resource: ShopifyAPI::Product.find(1234)
=end
    def initialize(*args)
      # the class name is the resource
      args.unshift(self.class.name.demodulize.underscore)

      # if we can be a child resource
      unless self.class.parents.nil? || self.class.parents.empty?
        options = args.extract_options!

        # find which parent we have.
        options.symbolize_keys!
        parent = options.keys.select{|k| self.class.parent_keys.include?(k)}
        raise "#{self.class.name} cannot have multiple parents: #{parent.inspect}" if parent.length > 1

        unless parent.empty?
          parent_id = options.delete(parent.first)

          # user can use parent_resource when parent type can vary at runtime
          if parent.first == :parent_resource
          # parent_resource: {product: 123}
            if parent_id.is_a?(Hash)
              raise "#{self.class.name} cannot have multiple parents: #{parent_id.inspect}" if parent_id.length > 1
              parent_key = parent_id.first.first
              parent_id = parent_id.first.last
            elsif parent_id.is_a?(ActiveResource::Base)
            # parent_resource: <ShopifyAPI::Product instance>
              parent_key = parent_id.class.collection_name.to_sym
              parent_element = parent_id.class.element_name.to_sym
              raise "#{parent_id.inspect} cannot be a parent of #{self.class.name}" unless self.class.parents.include?(parent_element)
              parent_id = parent_id.id
            end
          else
            parent_key = parent.first.to_s.sub(/_id$/,'').to_sym
            parent_id = parent_id[:id] if parent_id.is_a?(Hash)
            parent_id = parent_id.id if parent_id.respond_to?(:id)
          end
          options.merge!({:parent_resource => {parent_key => parent_id}})

        end
        args << options
      end
      super(*args)
    end      
  end
end
