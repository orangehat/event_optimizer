require 'test_helper'

class FavoriteUsersControllerTest < ActionController::TestCase
  setup do
    @favorite_user = favorite_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favorite_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favorite_user" do
    assert_difference('FavoriteUser.count') do
      post :create, favorite_user: { fb_id: @favorite_user.fb_id, fb_name: @favorite_user.fb_name, name: @favorite_user.name, tw_id: @favorite_user.tw_id, tw_name: @favorite_user.tw_name }
    end

    assert_redirected_to favorite_user_path(assigns(:favorite_user))
  end

  test "should show favorite_user" do
    get :show, id: @favorite_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @favorite_user
    assert_response :success
  end

  test "should update favorite_user" do
    put :update, id: @favorite_user, favorite_user: { fb_id: @favorite_user.fb_id, fb_name: @favorite_user.fb_name, name: @favorite_user.name, tw_id: @favorite_user.tw_id, tw_name: @favorite_user.tw_name }
    assert_redirected_to favorite_user_path(assigns(:favorite_user))
  end

  test "should destroy favorite_user" do
    assert_difference('FavoriteUser.count', -1) do
      delete :destroy, id: @favorite_user
    end

    assert_redirected_to favorite_users_path
  end
end
