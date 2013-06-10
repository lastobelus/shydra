module Shydra
  class Batch
    OVER_LIMIT_RESPONSE_CODE = 429

    attr_accessor :requests
    def initialize
      @requests = []
    end

    delegate :<<, :size, :clear,  to: :requests

    def finished?
      requests.all?{|r| !r.response.nil?}
    end

    def over_limit?
      requests.any? { |r| r.response && (r.response.code == OVER_LIMIT_RESPONSE_CODE) }
    end
  end
end
