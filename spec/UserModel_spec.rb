require 'spec_helper'

describe UserModel do
  it "can be instantiated" do
  	test = true
    test.should be_true
  end

  it "Normal Add" do
  	UserModel.add("test","test")
  	bool1 = UserModel.find_by_user("test")!=nil
  	bool2 = UserModel.find_by_password("test")!=nil
    boolean_result = (bool1 & bool2)
    boolean_result.should be_true
  end

  it "Add: Username Less Than 128 Characters" do
  	long_term = (0...130).map{65.+(rand(26)).chr}.join
  	result = UserModel.add(long_term,"wow")
  	boolean_result = (result == -3)
    boolean_result.should be_true
  end

  it "Add: Password Less Than 128 Characters" do
  	long_term = (0...130).map{65.+(rand(26)).chr}.join
  	result = UserModel.add("wow",long_term)
  	boolean_result = (result == -4)
  	boolean_result.should be_true
  end

  it "Add: Must have username" do
  	result = UserModel.add("","wow")
  	boolean_result = (result == -3)
    boolean_result.should be_true
  end

  it "Login: Random username and password" do
  	result = UserModel.login("random","random")
  	boolean_result = (result == -1)
    boolean_result.should be_true
  end

  it "Normal Login" do
  	new_model = UserModel.add("newbie","newbie")
  	result = UserModel.login("newbie","newbie")
  	boolean_result = (result > 0)
  end

  it "Logins Accumulate" do
  	new_model = UserModel.add("newbie2","newbie2")
  	UserModel.login("newbie2","newbie2")
  	old_count = UserModel.find_by_user("newbie2").count
  	UserModel.login("newbie2","newbie2")
  	new_count = UserModel.find_by_user("newbie2").count
  	boolean_result = (new_count == old_count+1)
    boolean_result.should be_true
  end

  it "Unique Username Required" do
  	UserModel.add("newbie3","newbie3")
  	result = UserModel.add("newbie3","newbie3")
  	boolean_result = (result == -2)
    boolean_result.should be_true
  end

  it "Bad Password" do
  	new_model = UserModel.add("newbie4","hi")
  	result = UserModel.login("newbie4","woa")
  	boolean_result = (result == -1)
    boolean_result.should be_true
  end


  it "Reset Fixture" do
  	UserModel.TESTAPI_resetFixture()
  	boolean_result = (UserModel.all.length==0)
    boolean_result.should be_true
  end

end