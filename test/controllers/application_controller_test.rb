require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  setup do
	@logins = Logins.new
	@logins.username = 'user1'
	@logins.password = 'abc'
	@logins.counter = 1
  end

  test "should get reset fixtures" do
    get :resetFixture
    assert_response :success
  end

  test "should get unit tests" do
    get :unitTests
    assert_response :success
  end

  test "should add login" do
  	assert_difference("Logins.count")	do
  		post :addUser, {"password" => @logins.password, "user" => @logins.username, "counter" => @logins.counter}, "CONTENT_TYPE" => 'application/json'
  	end
  end

  test "should not add invalid login" do
  	assert_no_difference("Logins.count")	do
  		post :addUser, {"password" => @logins.password, "user" => "", "counter" => @logins.counter}, "CONTENT_TYPE" => 'application/json'
  	end
  end

  test "should not add duplicate login" do
  	assert_no_difference("Logins.count")	do
  		post :addUser, {"password" => "MyString", "user" => "MyString", "counter" => 1}, "CONTENT_TYPE" => 'application/json'
  	end
  end

  test "should not add login that is too long" do
  	assert_no_difference("Logins.count")	do
  		post :addUser, {"password" => @logins.password, "user" => @logins.username * 32, "counter" => 1}, "CONTENT_TYPE" => 'application/json'
  	end
  end

  test "should not add password that is too long" do
  	assert_no_difference("Logins.count")	do
  		post :addUser, {"password" => @logins.password * 44, "user" => @logins.username, "counter" => 1}, "CONTENT_TYPE" => 'application/json'
  	end
  end
  
  test "should not allow blank password" do
  	assert_difference("Logins.count")	do
  		post :addUser, {"password" => "", "user" => @logins.username, "counter" => 1}, "CONTENT_TYPE" => 'application/json'
  	end
  end

  test "should increment counter on login" do
  	assert_difference("Logins.where(username: 'MyString').first.counter", 1)	do
  		post :login, {"password" => "MyString", "user" => "MyString", "counter" => 1}, "CONTENT_TYPE" => 'application/json'
  	end
  end

  test "should not increment counter on invalid password on login" do
  	assert_no_difference("Logins.where(username: 'MyString').first.counter")	do
  		post :login, {"password" => "MyStrung", "user" => "MyString", "counter" => 1}, "CONTENT_TYPE" => 'application/json'
  	end
  end
end
