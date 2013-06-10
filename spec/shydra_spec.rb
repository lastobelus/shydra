require 'spec_helper'

describe "Shydra" do
  context "api-limits" do
    describe '#update_api_limit' do
      it "sets the current requests left from a response"
      it "sets the first known time the api-limit was set"
      it "resets the first known time if the requests left increases"
      it "uses the response time if it is available"
      it "caches the results with memcache if it is available"
      it "synchronizes"
    end
  end
end
