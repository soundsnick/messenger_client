class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def auth
    if session[:token]
      Token.find_by(token: session[:token])
    else false
    end
  end

  def user
    if auth
      User.find_by(id: auth.user_id)
    else false
    end
  end
end
