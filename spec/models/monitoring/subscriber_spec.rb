require 'rails_helper'
# require 'active_job/test_helper'
require 'webmock/rspec'

RSpec.describe Monitoring::Subscriber, type: :model do
  include ActiveJob::TestHelper

  it "dispatches notification on creation if the content was already fetched" do
    stub_request(:get, "http://example.org/")
      .to_return body: '<!doctype html><html><head><title>Example Domain</title></head><body>Hello world!</body></html>'
    stub_request(:post, "https://gcm-http.googleapis.com/gcm/send")
      .to_return body: '{"multicast_id":8137295278192253139,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1471114573740287%faa30396faa30396"}]}'

    context = Monitoring::Context.new(url: "http://example.org/")
    perform_enqueued_jobs { context.save! }

    context.subscribers.create!(endpoint: "https://android.googleapis.com/gcm/send/ee5AUVXTN9o:APA91bE5UGE900VQSl7fqBtSilmeJXILkQY57LcSztb4zc-fpp0K84-5P3-aw2iArtgnTAEzw26OY4K48Omz0MnYmH__kKfd_hrpBexEI4HCEsuFcEzLOIkEMxLeH8wO2AKRRwWFB1CU")
    expect(a_request(:post, "https://gcm-http.googleapis.com/gcm/send")).to have_been_made
  end
end
