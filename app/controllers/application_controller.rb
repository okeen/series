class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def facebook_user
    @facebook_user ||= begin
      facebook_graph = Koala::Facebook::GraphAPI.new(params['access_token'])
      user = facebook_graph.get_object('me')
      puts user.inspect
      user[:facebook_id] = user.delete('id')
      user[:name] = user.delete('first_name')
      location = user.delete 'location'
      user[:location] = location['name']
      ['education','link', 'hometown', 'verified', 'updated_time'].each do |att|
        user.delete att
      end
      user
    end 

  end

  def facebook_user?
    !facebook_user.nil?
  end

  def facebook_session?
    current_user_session.try(:facebook_session?)
  end
end
