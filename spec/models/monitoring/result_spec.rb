require 'rails_helper'

RSpec.describe Monitoring::Result, type: :model do
  it "notifies context's subscribers if created result is different from the previous one" do
    @context = Monitoring::Context.create!(url: "http://example.org/")
    @context.results.create!(content: "foobar")
    @context.subscribers.create!(endpoint: "https://android.googleapis.com/gcm/send/ee5AUVXTN9o:APA91bE5UGE900VQSl7fqBtSilmeJXILkQY57LcSztb4zc-fpp0K84-5P3-aw2iArtgnTAEzw26OY4K48Omz0MnYmH__kKfd_hrpBexEI4HCEsuFcEzLOIkEMxLeH8wO2AKRRwWFB1CU")
    expect {
      @context.results.create!(content: "foobar")
    }.not_to change { Rpush::Notification.all.count }
    expect {
      @context.results.create!(content: "foobaz")
    }.to change { Rpush::Notification.all.count } .by(1)
  end
end
