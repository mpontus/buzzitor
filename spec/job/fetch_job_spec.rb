require 'rails_helper'
require 'support/test_app';

RSpec.describe FetchJob, type: :job do
  before do
    TestApp.boot do |server, app|
      @server = server
      @app = app
    end

    test_app_url = "http://#{@server.host}:#{@server.port}/";
    @context = Monitoring::Context.create!(url: test_app_url);
    @app.content = "<title>Hello world!</title>"
  
    allow(Webpush).to receive(:payload_send)
  end

  it "should download the latest content", :focus do
    FetchJob.perform_now(@context)
    expect(@context.results.last.title).to eq("Hello world!")

    @app.content = "<title>Foo bar</title>"
    FetchJob.perform_now(@context)
    expect(@context.results.last.title).to eq("Foo bar")
  end

  it "broadcasts new results via action cable" do
    expect(MonitoringChannel).to receive(:broadcast_to).with(@context, any_args)
    FetchJob.perform_now(@context)
  end

  describe "notifications" do
    before do
      @context.subscribers.create!(
        endpoint: "https://android.googleapis.com/gcm/send/e_8ZoEDHNRg:APA91bEyyhkkz5W67b5HcNitP1OtUT_7bsZBLSDgaBrvuV-CAVG-FeVB_ZiywQzii7peAuVifzCu2udu8EISwIZUoetIE39ODzwDXzulqpMPLKkp1C9Or_GPMNC1V8V0fvKuW4u_VZT7",
        keys: {
          "auth" => "wb2e4qEzCXAEjyCV48vjCQ==",
          "p256dh" => "BAFs0PT443mBiX4Zf1u_M_sOemvCxQbRTaV3zKhxOOTjiK7Wc5AaYoXoLZnug76BtKH89E6TTqZOa4POkurpMR8=",
        }
      )
    end

    it "should send welcoming notification after the initial fetch" do
      expect(Webpush).to receive(:payload_send)
      FetchJob.perform_now(@context)
    end

    context "after initial fetch" do
      before do
        FetchJob.perform_now(@context)
      end

      context "remote page remains the same" do
        it "should not send notifications" do
          expect(Webpush).not_to receive(:payload_send)
          FetchJob.perform_now(@context)
        end
      end

      context "remote page has changed" do

        before do
          @app.content = "Foo Bar"
        end

        it "should send notification" do
          expect(Webpush).to receive(:payload_send)
          FetchJob.perform_now(@context)
        end
      end
    end
  end

  describe "error handling" do
    before do
      allow(Buzzitor::PageFetcher).to receive(:fetch) do
        raise Capybara::Poltergeist::StatusFailError
                .new "Server inaccessible"
      end
    end

    it "creates erroneous result" do
      expect {
        FetchJob.perform_now(@context)
      }.to change(@context.results, :count).by(1)
      expect(@context.results.last.error_code).not_to be_nil
    end
  end
end
