require 'spec_helper'

describe Shydra::Batch do
  it "adds requests" do
    request = double("Request")
    subject << request
    expect(subject.requests).to include(request)
  end

  def request_and_response_mock(request_name, response_name=nil, response={})
    req = double(request_name)
    resp = response_name.nil? ? nil : double(response_name)
    if response[:code]
      resp.should_receive(:code).at_least(:once).and_return(response[:code])
    else
      resp.stub(:code).and_return(200) unless resp.nil?
    end
    if resp
      req.should_receive(:response).at_least(:once).and_return(resp)
    else
      req.stub(:response).and_return(resp)
    end
    req
  end

  describe "#finished?" do
    it "returns true when all the requests have a response" do
      r1 = request_and_response_mock("request 1", 'response 1')
      r2 = request_and_response_mock("request 2", 'response 2')
      subject << r1; subject << r2
      expect(subject.finished?).to be_truthy
    end

    it "returns false when not all the requests have a response" do
      r1 = request_and_response_mock("request 1", 'response 1')
      r2 = request_and_response_mock("request 2", nil)
      subject << r1; subject << r2
      expect(subject.finished?).to be_falsey
    end    
  end

  describe "#over_limit?" do
    before do
    end
    it "returns false when all the requests do not have response code 429" do
      r1 = request_and_response_mock("request 1", 'response 1', code: 200)
      r2 = request_and_response_mock("request 2", 'response 2', code: 500)
      subject << r1; subject << r2
      subject << r1; subject << r2
      expect(subject.over_limit?).to be_falsey
    end

    it "returns true when any request has response code 429" do
      r1 = request_and_response_mock("request 1", 'response 1', code: 200)
      r2 = request_and_response_mock("request 2", 'response 2', code: 429)
      r3 = request_and_response_mock("request 3") # over_limit will return true after finding the first 429
      subject << r1; subject << r2; subject << r3
      expect(subject.over_limit?).to be_truthy
    end    
  end

  


end
