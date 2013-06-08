require_relative 'response'

module Shydra  
  class Request < Typhoeus::Request
    SHOPIFY_API_MAX_LIMIT = 250

    attr_accessor :resource, :data_root
    attr_accessor :options

    def self.base_uri
      ShopifyAPI::Base.site
    end

    def self.headers
      ShopifyAPI::Base.headers
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

      @parent_resource = @options.delete(:parent_resource)
      @parent_resource, @parent_resource_id = @parent_resource.first if @parent_resource


      @id = @options.delete(:id)

      @options[:limit] ||= SHOPIFY_API_MAX_LIMIT

      resource_path = @resource
      resource_path = resource_path.pluralize unless (@resource == 'shop')
      resource_path = [@parent_resource.to_s.pluralize, @parent_resource_id, resource_path].join('/') if @parent_resource


      path = [resource_path]
      path.unshift('admin') unless Request.base_uri.path[-1] == '/' #handle quirk of URI.merge

      @data_root = nil

      if @count
        path << 'count'
        @options.delete(:limit)
        @data_root = 'count'
      elsif @id
        path << @id.to_s
        @data_root = @resource
      else
        @data_root = @resource.pluralize
      end

      path = path.join('/') + '.json'
      uri = Request.base_uri.merge(path)
      uri.query = @options.to_param unless @options.empty?

      super(uri.to_s, headers: Request.headers)
    end

    def finish(response, bypass_memoization = nil)
      response.extend Shydra::Response
      super(response, bypass_memoization)
    end

  end  
end


