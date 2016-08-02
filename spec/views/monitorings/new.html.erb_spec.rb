require 'rails_helper'

RSpec.describe "monitorings/new", type: :view do
  before(:each) do
    assign(:monitoring, Monitoring.new())
  end

  it "renders new monitoring form" do
    render

    assert_select "form[action=?][method=?]", monitorings_path, "post" do
    end
  end
end
