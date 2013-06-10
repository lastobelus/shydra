require 'spec_helper'

describe "Response" do
  before do
    @shopify_headers = {"X-Shopify-Access-Token"=>"yyyyyyyyy"}
     ShopifyAPI::Base.stub(:site).and_return(URI("https://xxxx:yyyy@cronin.myshopify.com/admin/"))
     ShopifyAPI::Base.stub(:headers).and_return(@shopify_headers)
  end
  describe '#data' do
    it "returns the count as an int for a count request" do
      response = Typhoeus::Response.new(code: 200, body: "{\"count\":14}")
      Typhoeus.stub(/cronin/).and_return(response)
      response = Shydra::Request.new(:product, :count).run

      expect(response.data).to eq 14
    end

    it "returns a hash of product attributes for an id request" do
      response = Typhoeus::Response.new(code: 200, body: "{\"product\":{\"body_html\":\"yo yo yo baby pop\",\"id\":137632345}}")
      Typhoeus.stub(/cronin/).and_return(response)
      response = Shydra::Request.new(:product, id: 137632345).run

      expect(response.data).to eq( {"body_html"=>"yo yo yo baby pop", "id"=>137632345})
    end

    it "returns an array of hashes of product attributes for an collection request" do
      response = Typhoeus::Response.new(code: 200, body: "{\"products\":[{\"body_html\":\"yo yo yo baby pop\",\"id\":123},{\"body_html\":\"yowza\",\"id\":456}]}")
      Typhoeus.stub(/cronin/).and_return(response)
      response = Shydra::Request.new(:product).run

      expect(response.data).to eq( [{"body_html"=>"yo yo yo baby pop", "id"=>123}, {"body_html"=>"yowza", "id"=>456}] )
    end
  end

  
end
