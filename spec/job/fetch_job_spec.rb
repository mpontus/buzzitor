require 'rails_helper'
require 'support/test_app';

RSpec.describe FetchJob, type: :job do
  before do
    # Use TestApp as a monitoring target

    TestApp.boot do |server, app|
      @server = server
      @app = app
    end

    test_app_url = "http://#{@server.host}:#{@server.port}/";
    @context = Monitoring::Context.create!(url: test_app_url);
    @app.content = "Hello world!"
  end

  it "should download the latest content" do
    FetchJob.perform_now(@context)
    expect(@context.results.last.content).to include("Hello world!")

    @app.content = "Foo bar"
    FetchJob.perform_now(@context)
    expect(@context.results.last.content).to include("Foo bar")
  end

  it "broadcasts new results via action cable" do
    expect(MonitoringChannel).to receive(:broadcast_to).with(@context, any_args)
    FetchJob.perform_now(@context)
  end

  describe "notifications" do
    before do
      @context.subscribers.create! endpoint: "https://android.googleapis.com/gcm/send/ae5AUVXTN9o:APA91bE5UGE900VQSl7fqBtSilmeJXILkQY57LcSztb4zc-fpp0K84-5P3-aw2iArtgnTAEzw26OY4K48Omz0MnYmH__kKfd_hrpBexEI4HCEsuFcEzLOIkEMxLeH8wO2AKRRwWFB1CU"
    end

    it "should send welcoming notification after the initial fetch" do
      expect {
        FetchJob.perform_now(@context)
      }.to change { Rpush::Notification.all.count } .by(1)
    end

    context "after initial fetch" do
      before do
        FetchJob.perform_now(@context)
      end

      context "remote page remains the same" do
        it "should not send notifications" do
          expect {
            FetchJob.perform_now(@context)
          }.not_to change { Rpush::Notification.all.count }
        end
      end

      context "remote page has changed" do

        before do
          @app.content = "Foo Bar"
        end

        it "should send notification" do
          expect {
            FetchJob.perform_now(@context)
          }.to change { Rpush::Notification.all.count } .by(1)
        end
      end
    end
  end
end
