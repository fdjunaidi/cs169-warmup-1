class UserModelsController < ApplicationController
  # GET /user_models
  # GET /user_models.json
  def index
    @user_models = UserModel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_models }
    end
  end

  # GET /user_models/1
  # GET /user_models/1.json
  def show
    @user_model = UserModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user_model }
    end
  end

  # GET /user_models/new
  # GET /user_models/new.json
  def new
    @user_model = UserModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user_model }
    end
  end

  # GET /user_models/1/edit
  def edit
    @user_model = UserModel.find(params[:id])
  end

  # POST /user_models
  # POST /user_models.json
  def create
    @user_model = UserModel.new(params[:user_model])

    respond_to do |format|
      if @user_model.save
        format.html { redirect_to @user_model, :notice => 'User model was successfully created.' }
        format.json { render :json => @user_model, :status => :created, :location => @user_model }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_models/1
  # PUT /user_models/1.json
  def update
    @user_model = UserModel.find(params[:id])

    respond_to do |format|
      if @user_model.update_attributes(params[:user_model])
        format.html { redirect_to @user_model, :notice => 'User model was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_models/1
  # DELETE /user_models/1.json
  def destroy
    @user_model = UserModel.find(params[:id])
    @user_model.destroy

    respond_to do |format|
      format.html { redirect_to user_models_url }
      format.json { head :no_content }
    end
  end
end
