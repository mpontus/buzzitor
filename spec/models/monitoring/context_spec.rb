require 'rails_helper'

RSpec.describe Monitoring::Context, type: :model do
  it "has many results" do
    result = Monitoring::Result.new(content: "foobar")
    context = Monitoring::Context.new(url: "http://example.org/")
    context.results << result
    context.save!
    expect(context.reload.results.first).to eq(result)
  end
end
