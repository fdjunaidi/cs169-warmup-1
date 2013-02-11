# user_model.rb
require 'user_model'

describe UserModel do
   result = UserModel.add("test","test")
   result.should eq(1)
end