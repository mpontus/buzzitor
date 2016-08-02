require 'rails_helper'

RSpec.describe "monitorings/show", type: :view do
  before(:each) do
    @monitoring = assign(:monitoring, Monitoring.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
