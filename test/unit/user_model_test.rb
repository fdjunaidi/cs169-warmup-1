require 'test_helper'

class UserModelTest < ActiveSupport::TestCase

  test "Normal Add" do
  	UserModel.add("test","test")
  	bool1 = UserModel.find_by_user("test")!=nil
  	bool2 = UserModel.find_by_password("test")!=nil
    assert (bool1 & bool2)
  end

  test "Add: Username Less Than 128 Characters" do
  	long_term = (0...130).map{65.+(rand(26)).chr}.join
  	result = UserModel.add(long_term,"wow")
  	assert (result == -3)
  end


  test "Add: Password Less Than 128 Characters" do
  	long_term = (0...130).map{65.+(rand(26)).chr}.join
  	result = UserModel.add("wow",long_term)
  	assert (result == -4)
  end

  test "Add: Must have username" do
  	result = UserModel.add("","wow")
  	assert (result == -3)
  end

  test "Login: Random username and password" do
  	result = UserModel.login("random","random")
  	assert (result == -1)
  end

  test "Normal Login" do
  	new_model = UserModel.add("newbie","newbie")
  	result = UserModel.login("newbie","newbie")
  	assert (result > 0)
  end

  test "Logins Accumulate" do
  	new_model = UserModel.add("newbie2","newbie2")
  	UserModel.login("newbie2","newbie2")
  	old_count = UserModel.find_by_user("newbie2").count
  	UserModel.login("newbie2","newbie2")
  	new_count = UserModel.find_by_user("newbie2").count
  	assert (new_count == old_count+1)
  end

  test "Unique Username Required" do
  	UserModel.add("newbie3","newbie3")
  	result = UserModel.add("newbie3","newbie3")
  	assert (result == -2)
  end

  test "Bad Password" do
  	new_model = UserModel.add("newbie4","hi")
  	result = UserModel.login("newbie4","woa")
  	assert (result == -1)
  end

  test "Reset Fixture" do
  	UserModel.TESTAPI_resetFixture()
  	assert (UserModel.all.length==0)
  end

end
