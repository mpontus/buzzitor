require 'rails_helper'

RSpec.describe "monitorings/edit", type: :view do
  before(:each) do
    @monitoring = assign(:monitoring, Monitoring.create!())
  end

  it "renders the edit monitoring form" do
    render

    assert_select "form[action=?][method=?]", monitoring_path(@monitoring), "post" do
    end
  end
end
