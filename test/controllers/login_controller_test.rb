require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get github" do
    get login_github_url
    assert_response :success
  end

end
