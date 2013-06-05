module Shydra  
  class Request < Typhoeus::Request
    SHOPIFY_API_MAX_LIMIT = 250

    attr_accessor :resource
    attr_accessor :options

    def self.base_uri
      ShopifyAPI::Base.site
    end

    def initialize(*args)
      @options = args.extract_options!
      @count = @options.delete(:count)
      if args[1] == :count
        @count = true
      end

      @resource = @options.delete(:resource)
      @resource ||= args.first
      @resource ||= 'shop'
      @resource = @resource.to_s

      @id = @options.delete(:id)

      @options[:limit] ||= SHOPIFY_API_MAX_LIMIT

      @resource = @resource.pluralize unless (@resource == 'shop')

      path = ['admin', @resource]
      if @count
        path << 'count'
        @options.delete(:limit)
      elsif @id
        path << @id.to_s
      end

      path = path.join('/') + '.json'
      uri = Request.base_uri.merge(path)
      uri.query = @options.to_param unless @options.empty?

      super(uri.to_s)
    end
  end
end
