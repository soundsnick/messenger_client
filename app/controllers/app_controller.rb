class AppController < ApplicationController
  require 'digest'


  def main
    redirect_to login_path if not auth
    @users = User.all.to_json.html_safe
  end

  def im
    redirect_to login_path if not auth
    if (@receiver = User.find_by(id: params[:pid]))
      @messages = Message.where("user_id = ? and pid = ? or user_id = ? and pid = ?", user.id, @receiver.id, @receiver.id, user.id).to_json(:include => { :user => { :only => :username } }).html_safe
      render 'app/im'
    else redirect_to root_path, notice: 'Пользователь не найден!'
    end
  end

  def login
    redirect_to root_path if auth
  end

  def settings
  end

  def user_update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to settings_path, notice: 'Saved.'
    else
      redirect_to settings_path, notice: 'Error'
    end
  end

  def authorisation
    redirect_to login_path, notice: 'Fill all the fields' unless params[:username] and params[:password]
    password = Digest::SHA256.hexdigest params[:password]
    @user = User.find_by(username: params[:username], password: password)
    if @user
      session[:token] = create_token @user
      redirect_to root_path
    else
      if User.find_by(username: params[:username])
        redirect_to login_path, notice: 'Incorrect password'
      else
        @user = User.new
        @user.username = params[:username]
        @user.password = password
        @user.save
        session[:token] = create_token @user
        redirect_to root_path
      end
    end
  end

  def logout
    if auth
      token = Token.find_by(token: session[:token])
      token.destroy if token
    end
    session[:token] = nil
    redirect_to login_path
  end

  private

  def create_token(user)
    access_token = Token.new
    access_token.user_id = user.id
    token = (Digest::SHA256.hexdigest rand(123).to_s) + (Digest::SHA256.hexdigest user.username)
    access_token.token = token
    access_token.save
    token
  end

  def user_params
    params.require(:user).permit(:username, :image)
  end

end