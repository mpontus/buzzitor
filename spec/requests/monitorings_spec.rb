require 'rails_helper'

RSpec.describe "Monitorings", type: :request do
  describe "GET /monitorings" do
    it "works! (now write some real specs)" do
      get monitorings_path
      expect(response).to have_http_status(200)
    end
  end
end
