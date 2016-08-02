require 'rails_helper'

RSpec.describe "monitorings/index", type: :view do
  before(:each) do
    assign(:monitorings, [
      Monitoring.create!(),
      Monitoring.create!()
    ])
  end

  it "renders a list of monitorings" do
    render
  end
end
