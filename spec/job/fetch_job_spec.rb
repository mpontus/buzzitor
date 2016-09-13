require 'rails_helper'
require 'support/fake_host';


RSpec.describe FetchJob, type: :job do
  setup do
    allow(Webpush).to receive(:payload_send)
  end

  setup do
    @fake_host = FakeHost.new do
      get '/' do
        "<title>Hello world!</title>"
      end
    end
  end

  teardown do
    @fake_host.shutdown
  end

  before do
    @context = Monitoring::Context.create!(url: @fake_host.base_url);
  end

  it "should download the latest content" do
    FetchJob.perform_now(@context)
    expect(@context.results.last.title).to eq("Hello world!")

    @fake_host.configure do
      get "/" do
        "<title>Foo bar</title>"
      end
    end
    
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
          @fake_host.configure do
            get "/" do
              "Foo bar"
            end
          end
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
      @fake_host.configure do
        get '/' do
          sleep 1
          "Hello world!"
        end
      end
    end

    before do
      @original_timeout = APP_CONFIG['page_fetcher_timeout']
      APP_CONFIG['page_fetcher_timeout'] = 0
    end

    after do
      APP_CONFIG['page_fetcher_timeout'] = @original_timeout
    end

    it "creates erroneous result" do
      expect {
        FetchJob.perform_now(@context)
      }.to change(@context.results, :count).by(1)
      expect(@context.results.last.error_code).not_to be_nil
    end
  end
end
