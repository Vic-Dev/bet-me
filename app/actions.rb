# Homepage (Root path)
require 'pry'

helpers do
  def current_user
    if session.has_key?(:user_session)
      user = User.find_by_login_token(session[:user_session])
    else
      nil
    end
  end
end

def authenticate_user
  redirect'/user/login' unless current_user
end

get '/' do
  session[:user_session] ||=nil
  erb :index
end

get '/index' do
  erb :index
end

get '/login' do
  erb :'user/login'
end

get '/user' do
  @users = User.all
  erb :'users/index'
end

get '/user/signup' do
  @user = User.new
  erb :'users/signup'
end

post '/users/signup' do
  @user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    password: params[:password]
    )
  if @user.save
    redirect '/users/login'
  else
    redirect'/index'
  end
end





get '/user/profile' do
  if current_user
    erb :'profile'
  else
    redirect '/index'
  end
end


get '/profile/:id' do
  @user = User.find(params[:id])
  @challenges = @user.challenges
  erb :'user/profile'
end
end
