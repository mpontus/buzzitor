require 'rails_helper'

RSpec.describe Monitoring::Context, type: :model do
  it "enqueues FetchJob" do
    context = Monitoring::Context.new(url: "http://example.org/")
    expect {
      context.save!
    }.to have_enqueued_job(FetchJob).with(context)
  end

  it "has many results" do
    result = Monitoring::Result.new(content: "foobar")
    context = Monitoring::Context.new(url: "http://example.org/")
    context.results << result
    context.save!
    expect(context.reload.results.first).to eq(result)
  end

  it "will fetch page and save it as a result" do
    context = Monitoring::Context.new(url: "http://example.org")
    expect {
      context.fetch!
    }.to change(context.results, :length).by(1)
  end

end
