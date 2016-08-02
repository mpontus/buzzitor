require 'test_helper'

class CoreControllerTest < ActionDispatch::IntegrationTest
  test "should get serviceworker" do
    get core_serviceworker_url
    assert_response :success
  end

  test "should get manifest" do
    get core_manifest_url
    assert_response :success
  end

end
