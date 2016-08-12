require 'rails_helper'

RSpec.describe Monitoring::Context, type: :model do
  it "can be created" do
    result = Monitoring::Result.new(content: "foobar")
    expect(result.content).to eq("foobar")
  end
end
