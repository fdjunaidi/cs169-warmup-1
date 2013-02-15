class UsersController < ApplicationController
  
  #def delegate
    #if params[:login]
      #ogin_post(params[:user],params)
    #else
      #add_post()
    #end
  #end

  def add_get
  	@user_models = UserModel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_models, :status=>200 }
    end
  end

  def add_post
  	user = params[:user]
  	password = params[:password]
  	errCode = UserModel.add(user,password)
  	if (errCode>0)
  		count = errCode
  		errCode = 1
  	end
  	final_obj = {:errCode=> errCode, :count=>count}
  	respond_to do |format|
  		format.json { render :json=>final_obj, :status=>200}
  	end
  end

  def login_get
  	@user_models = UserModel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_models, :status=>200}
    end
  end

   def resetFixture
    result = UserModel.TESTAPI_resetFixture()
    final_obj = {:errCode=>result}
    respond_to do |format|
      format.json { render :json=>final_obj, :status=>:ok}
    end
  end

  def login_post
  	user = params[:user]
  	password = params[:password]
  	errCode = UserModel.login(user,password)
  	if (errCode>0)
  		count = errCode
  		errCode = 1
      final_obj = {:errCode=> errCode, :count=>count}
      respond_to do |format|
        format.json { render :json=>final_obj, :status=>200}
      end
  	else
  	 final_obj = {:errCode=> errCode}
  	 respond_to do |format|
  		  format.json { render :json=>final_obj, :status=>200}
  	 end
    end
  end
  

  def unitTests
    #shell_command = "ruby -Itest test/unit/user_model_test.rb > results.txt"
    #shell_command = "rake test:units > app/controllers/results.txt"
    shell_command = "rspec spec/UserModel_spec.rb > results.txt"
    system(shell_command)
    totalTests = 11
    nrFailed = 0
    output = ""
    File.open("results.txt", "r").each_line do |line|
      output = output + "\n" + line
      if ((line.include? "tests") & (line.include? "assertions") & (line.include? "failures") & (line.include? "errors"))
          broken_up = line.split(",")
          broken_up.each do |term|
            puts term
            value = /\d+/.match(term)
            puts " value start"
            puts value
            puts "value end "
            value = value[0]
            if term.include? "examples"
              totalTests = Integer(value)
            elsif  term.include? "fail"
              nrFailed = Integer(value)
            end
          end
      end 
    end
    final_obj = {:totalTests=>totalTests, :nrFailed=>nrFailed, :output=>output}
    respond_to do |format|
      format.json { render :json=>final_obj,:status=>200}
    end
  end

end
