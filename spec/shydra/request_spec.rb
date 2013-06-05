require 'spec_helper'

require 'shydra/request'


describe "Shydra::Request" do
  before do
     ShopifyAPI::Base.stub(:site).and_return(URI("https://xxxx:yyyy@cronin.myshopify.com/admin"))
  end

  subject{ Shydra::Request.new() }
  let(:store_uri){ URI("https://xxxx:yyyy@cronin.myshopify.com/admin")}

  specify{ expect(subject).to be_a_kind_of(Typhoeus::Request)}

  it "gets the base url from Shopify API" do
    expect(Shydra::Request.base_uri).to eq(store_uri)
  end

  it "creates resource collection uri" do
    expect(Shydra::Request.new(:product).url).to eq(
      "#{store_uri.to_s}/products.json?limit=250")
  end

  it "creates resource collection uri with params" do
    expect(Shydra::Request.new(:product, collection_id: 789, vendor: 'bob').url).to eq(
      "#{store_uri.to_s}/products.json?collection_id=789&limit=250&vendor=bob")
  end

  it "sets the resource to shop by default" do
    expect(Shydra::Request.new.url).to eq(
      "#{store_uri.to_s}/shop.json?limit=250")
  end

  it "creates resource by id uri" do
    expect(Shydra::Request.new(:product, id: 12345).url).to eq(
      "#{store_uri.to_s}/products/12345.json?limit=250")
  end

  it "creates resource count uri" do
    expect(Shydra::Request.new(:product, :count).url).to eq(
      "#{store_uri.to_s}/products/count.json")
  end

  it "creates resource count uri with params" do
    expect(Shydra::Request.new(:product, :count, collection_id: 789, vendor: 'bob').url).to eq(
      "#{store_uri.to_s}/products/count.json?collection_id=789&vendor=bob")
  end
end
