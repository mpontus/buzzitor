require 'rails_helper'

RSpec.describe Monitoring::Subscriber, type: :model do
  before do
    stub_request(:get, /example.org/)
      .to_return body: <<-EOS
                        <!doctype html>
                        <html>
                          <head>
                            <title>Example Domain</title>
                          </head>
                          <body>Hello world!</body>
                        </html>
                        EOS
  end

  it "dispatches notification on creation if the content was already fetched"  do
    context = Monitoring::Context.new(url: "http://example.org/")
    FetchJob.perform_now(context)
    expect {
      context.subscribers.create!(endpoint: "https://android.googleapis.com/gcm/send/ee5AUVXTN9o:APA91bE5UGE900VQSl7fqBtSilmeJXILkQY57LcSztb4zc-fpp0K84-5P3-aw2iArtgnTAEzw26OY4K48Omz0MnYmH__kKfd_hrpBexEI4HCEsuFcEzLOIkEMxLeH8wO2AKRRwWFB1CU")
    }.to change { Rpush::Notification.all.count } .by(1)
  end
end
