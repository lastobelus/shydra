require 'spec_helper'

describe Shydra::Resources::Product do
  before do
     ShopifyAPI::Base.stub(:site).and_return(URI("https://xxxx:yyyy@cronin.myshopify.com/admin/"))
  end

  let(:store_uri){ URI("https://xxxx:yyyy@cronin.myshopify.com/admin/")}

  it "creates a product request" do
    expect(Shydra::Resources::Product.new(:product, id: 12345).url).to eq(
        store_uri.to_s + "products/12345.json?limit=250")
  end
end
