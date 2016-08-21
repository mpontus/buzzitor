require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Monitoring::Context, type: :model do
  before do
    stub_request(:get, "http://example.org/")
      .to_return body: '<!doctype html><html><head><title>Example Domain</title></head><body>Hello world!</body></html>'
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
