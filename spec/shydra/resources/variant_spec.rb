require 'spec_helper'

describe Shydra::Resources::Variant do
  before do
     ShopifyAPI::Base.stub(:site).and_return(URI("https://xxxx:yyyy@cronin.myshopify.com/admin/"))
  end

  let(:store_uri){ URI("https://xxxx:yyyy@cronin.myshopify.com/admin/")}

  it "creates a variant request" do
    expect(Shydra::Resources::Variant.new(id: 12345).url).to eq(
        store_uri.to_s + "variants/12345.json?limit=250")
  end


  it "creates a product variant request" do
    expect(Shydra::Resources::Variant.new(product_id: 7777).url).to eq(
        store_uri.to_s + "products/7777/variants.json?limit=250")
    expect(Shydra::Resources::Variant.new(product: 7777).url).to eq(
        store_uri.to_s + "products/7777/variants.json?limit=250")
    expect(Shydra::Resources::Variant.new(product: {id: 7777}).url).to eq(
        store_uri.to_s + "products/7777/variants.json?limit=250")
  end

  it "creates a product variant request from a shopify object" do
    product = ShopifyAPI::Product.new(id: 888)
    expect(Shydra::Resources::Variant.new(product: product).url).to eq(
      store_uri.to_s + "products/888/variants.json?limit=250")
  end

  it "creates a variant request from a parent_resource" do
    # expect(Shydra::Resources::Variant.new(parent_resource: {product: 7777}).url).to eq(
    #     store_uri.to_s + "products/7777/variants.json?limit=250")

    product = ShopifyAPI::Product.new(id: 888)
    expect(Shydra::Resources::Variant.new(parent_resource: product).url).to eq(
        store_uri.to_s + "products/888/variants.json?limit=250")

    metafield = ShopifyAPI::Metafield.new(id: 444)
    expect{Shydra::Resources::Variant.new(parent_resource: metafield)}.to raise_error(
      /cannot be a parent of/
    )
  end
end
