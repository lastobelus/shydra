require 'oj'
module Shydra
  module Response
    def data
      json = Oj.load(response_body)
      case response_code
      when 200
        json[request.data_root]
      else
        json
      end
    end
  end
end
 