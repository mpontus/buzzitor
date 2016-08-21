require 'rails_helper'

RSpec.describe FetchJob, type: :job do
  before do
    stub_request(:get, "http://example.org/")
      .to_return body: <<-EOS
                        <!doctype html>
                        <html>
                          <head>
                            <title>Example Domain</title>
                          </head>
                          <body>Hello world!</body>
                        </html>
                        EOS
    @context = Monitoring::Context.create! url: "http://example.org/"
  end

  it "should send welcoming notification to all existing subscribers after first result has been fetched" do
    @context.subscribers.create! endpoint: "https://android.googleapis.com/gcm/send/ae5AUVXTN9o:APA91bE5UGE900VQSl7fqBtSilmeJXILkQY57LcSztb4zc-fpp0K84-5P3-aw2iArtgnTAEzw26OY4K48Omz0MnYmH__kKfd_hrpBexEI4HCEsuFcEzLOIkEMxLeH8wO2AKRRwWFB1CU"
    expect {
      FetchJob.perform_now(@context)
    }.to change { Rpush::Notification.all.count } .by(1)
  end

  it "should broadcast new results for a context via action cable" do
    expect(MonitoringChannel).to receive(:broadcast_to).with(@context, any_args)
    FetchJob.perform_now(@context)
  end
end
