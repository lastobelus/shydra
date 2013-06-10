require "shydra/version"
require "typhoeus"
require "shopify_api"
require 'shydra/request'
require 'shydra/response'
require 'shydra/resource'
require 'shydra/resources/product'
require 'shydra/resources/metafield'
require 'shydra/resources/variant'

require 'shydra/batch'

module Shydra
  class << self
    attr_accessor :max_concurrency
  end
end

Shydra.max_concurrency = 20