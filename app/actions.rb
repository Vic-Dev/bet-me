# Homepage (Root path)
require 'pry'


get '/' do
  redirect '/index'
end

get '/index' do
  erb :index
end

def current_user

  if cookies.has_key? :remember_me
    user = User.find_by_remember_token(cookies[:remember_me])
    return user if user
  end

  if session.has_key?(:user_session)
    user = User.find_by_login_token(session[:user_session])
  else
    nil
  end
end

get '/user/profile' do
  if current_user
    erb :'profile'
  else
    redirect '/index'
  end
end

post '/session' do
  @user = User.find_by_email(params[:email])
  if @user && @user.authenticate(params[:password])
    session[:user_session] = SecureRandom.hex
    @user.login_token = session[:user_session]

    if params.has_key?('remember_me') && params[:remember_me] == 'true'

      if @user.remember_token
        response.set_cookie :remember_me, {value: @user.remember_token, max_age: "2592000" }
      else
        response.set_cookie :remember_me, {value: SecureRandom.hex, max_age: "2592000" }
        @user.remember_token = cookies[:remember_me]
      end
    end

    @user.save
    redirect '/user/profile'
  else
    erb :login
  end
end
