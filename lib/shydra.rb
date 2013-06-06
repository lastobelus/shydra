require "shydra/version"
require "typhoeus"
require "shopify_api"
require 'shydra/request'
require 'shydra/response'

module Shydra
  class << self
    attr_accessor :max_concurrency
  end
end

Shydra.max_concurrency = 20