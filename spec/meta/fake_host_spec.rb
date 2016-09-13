require 'spec_helper';
require 'support/fake_host';
require 'byebug'


RSpec.describe FakeHost do
  subject do
    Net::HTTP::get(URI(@fake_host.base_url))
  end

  before do
    @fake_host = FakeHost.new do
      get '/' do
        "Hello world!"
      end
    end
  end

  it "can be configured to return canned response" do
    expect(subject).to eq("Hello world!")
  end

  context "lifecycle" do
    before do
      @fake_host.configure do
        get "/" do
          "Foo bar!"
        end
      end
    end

    it "can be reconfigured" do
      expect(subject).to eq("Foo bar!")
    end
  end

  context "shutting down" do
    before do
      @fake_host.shutdown
    end

    it "can be shut down" do
      expect {
        subject
      }.to raise_error(Errno::ECONNREFUSED)
    end
  end
end
