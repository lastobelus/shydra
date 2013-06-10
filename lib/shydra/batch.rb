module Shydra
  class Batch

    attr_accessor :requests
    def initialize
      @requests = []
    end

    delegate :<<, :size, :clear,  to: :requests

    def finished?
      requests.all?{|r| ! r.response.nil?}
    end
  end
end
