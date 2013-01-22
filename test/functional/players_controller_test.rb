require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  test "should get draftables" do
    get :draftables
    assert_response :success
  end

end
