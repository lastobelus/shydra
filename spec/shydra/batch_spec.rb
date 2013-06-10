require 'spec_helper'

describe Shydra::Batch do
  it "adds requests" do
    request = double("Request")
    subject << request
    expect(subject.requests).to include(request)
  end

  describe "#finished?" do
    it "returns true when all the requests have a response" do
      r1 = double("request 1"); r1.should_receive(:response).and_return(double('response 1'))
      r2 = double("request 2"); r2.should_receive(:response).and_return(double('response 2'))
      subject << r1; subject << r2
      expect(subject.finished?).to be_true
    end

    it "returns false when not all the requests have a response" do
      r1 = double("request 1"); r1.should_receive(:response).and_return(double('response 1'))
      r2 = double("request 2"); r2.should_receive(:response).and_return(nil)
      subject << r1; subject << r2
      expect(subject.finished?).to be_false
    end
    
  end


end
