class UsersController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
#  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    fb_user = facebook_user
    logger.debug "FB User: #{fb_user}"
    @user = User.new(fb_user)
    if @user.save(:validate => false)
      flash[:notice] = "Account registered!"
      render :json => {:status => 'ok', :user => @user}.to_json
    else
      render :json => {:status => 'error', :error => @user.errors}.to_json, :status => :unprocessable_entity
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end