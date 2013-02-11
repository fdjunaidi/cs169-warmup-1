class UserModel < ActiveRecord::Base
  attr_accessible :count, :password, :user
  validates :user, :presence => true,
                    :length => { :maximum => 128 }
  validates :password, :length => { :maximum => 128 }

  def self.login(user,password) #self. is to make this a static method
    find_user = UserModel.find_by_user(user)
    if (find_user==nil)
      return -1
    end
    result = (password == UserModel.find_by_password(password).password)
    if (result==true)
      find_user.count = find_user.count+1
      find_user.save
      return find_user.count
    else 
      return -1
    end
  end

  def self.add(user,password)
    find_user = UserModel.find_by_user(user)
    if (find_user!=nil)
      return -2
    end
    new_user = UserModel.new(:user=>user,:password=>password,:count=>1)
    result = new_user.save
    if (result==false)
        list = new_user.errors.full_messages
        list.each do |error|
          if (error.include? "Password")
            return -4 # Password should be at most 128 characters
          end
        end
        return -3 # Username should be non-empty and at most 128 characters
    end
    return new_user.count
  end

  def self.TESTAPI_resetFixture()
    UserModel.destroy_all()
    return 1
  end


end
