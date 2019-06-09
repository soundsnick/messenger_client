class ApiController < ApplicationController

  def userGetByToken
    if params[:token]
      if @user = Token.find_by(token: params[:token]).user_id
        @user = User.find_by(id: @user);
        response_json 'success', @user
      else
        session[:token] = nil
        response_json 'no auth'
      end
    else
      response_json 'no token'
    end
  end

  def userGetById
    if params[:id]
      if @user = User.find_by(id: params[:id])
        response_json 'success', @user
      else
        response_json 'no user'
      end
    else
      response_json 'no id'
    end
  end

  def addMessage
    if params[:token] and params[:user_id] and params[:pid] and params[:text]
      if @user = Token.find_by(token: params[:token]).user_id and @pid = User.find_by(id: params[:pid])
        @m = Message.new
        @m.user_id = @user
        @m.pid = params[:pid]
        @m.text = params[:text]
        response_json 'success', @m if @m.save
      else
        response_json 'error'
      end
    else
      response_json 'error'
    end
  end

  private

  def response_json(msg, body=nil)
    render json: {
        'message': msg,
        'body': body
    }
  end
end