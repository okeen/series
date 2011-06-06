class UserSessionsController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
#  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    fb_user = facebook_user
    logger.debug "FB User: #{fb_user}"
    @user = User.with_facebook_uid(fb_user[:facebook_id])
    @user_session = UserSession.new(
                          :user => @user,
                          :access_token => params[:access_token],
                          :expires => params[:expires] )

    if @user_session.save()
      flash[:notice] = "Login successful!"
      render :json => {:status => 'ok', :user => @user_session}.to_json
    else
      render :json => {:status => 'error', :error => @user_session.errors}.to_json, :status => :unprocessable_entity
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end