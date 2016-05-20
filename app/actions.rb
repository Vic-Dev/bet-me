require_relative('./actions/profile')
require_relative('./actions/challenges')

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

#=========================
# Login, signup and logout
#=========================

get '/user/signup' do
  @user = User.new
  erb :'users/signup'
end

post '/user/signup' do
  @user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    password: params[:password]
    )
  if @user.save
    @filename = "#{@user.id}_profile_photo"
    file = params[:file][:tempfile]
    File.open("./public/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    authenticate_user
    redirect '/user/profile'
  else
    redirect'/index'
  end
end

post '/user/login' do
  @user = User.find_by_email(params[:email])
  if @user && @user.authenticate(params[:password])
    session[:user_session] = SecureRandom.hex
    @user.login_token = session[:user_session]
    @user.save
    # redirect '/user/profile/'
    erb :index

  else
    erb :index
  end
end


post '/user/logout' do
  session.clear
  erb :index
end

#=====================
# Users
#=====================
get '/user/profile' do
  if current_user
    erb :'profile'
  else
    redirect '/index'
  end
end

# get '/profile/:id' do
#   @user = User.find(params[:id])
#   @challenges = @user.challenges
#   erb :'user/profile'
# end

get '/user/profile/:id' do
  @current_challenges = Challenge.where("end_time > ?", Time.current)
  @expired_challenges = Challenge.where("start_time < ?", Time.current)
  @user = User.find(params[:id])
  @challenges = @user.challenges.order(end_time: :desc)
  erb :'user/profile'
end

#============
# challenges
#============

get '/challenges' do
  @current_challenges = Challenge.where("end_time > ?", Time.current)
  @expired_challenges = Challenge.where("start_time < ?", Time.current)
  erb :'challenges/index'
end

get '/challenges/:id' do
  @user = current_user
  @is_creator = Record.where("role = ? AND user_id = ?",'creator',@user.id)
  @is_voter = Record.where("role = ? AND user_id = ?",'voter',@user.id)
  @challenge = Challenge.find(params[:id])
  #@voter_result is number of TRUE votes
  @true_votes = @challenge.users.where('vote_result = ?',true).count(:vote_result)
  #subtract the creator becasue he cannot vote
  @total_voters = @challenge.users.length - 1
  @post_vote_result = (@true_votes >= @total_voters/2) ? true : false
  erb :'challenges/profile'
end
