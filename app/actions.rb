require_relative('./actions/profile')
require_relative('./actions/challenges')

# Homepage (Root path)
require 'pry'

enable :sessions

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
  if current_user
    true
  else
    redirect '/user/login'
  end
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
  session[:user_session] = SecureRandom.hex
  @user.login_token = session[:user_session]
  @user.save
  if @user.save
    unless params[:file].nil?
      @filename = "#{@user.id}_profile_photo.jpg"
      file = params[:file][:tempfile]
      File.open("./public/images/#{@filename}", 'wb') do |f|
        f.write(file.read)
      end
    end
    authenticate_user
    redirect '/user/profile'
  else
    redirect'/index'
  end
end

get '/user/login' do

end

post '/user/login' do
  @user = User.find_by_email(params[:email])
  if @user && @user.authenticate(params[:password])
    session[:user_session] = SecureRandom.hex
    @user.login_token = session[:user_session]
    @user.save
    redirect '/user/profile'
  else
    erb :index
  end
end


get '/user/logout' do
  session.clear
  erb :index
end


#=====================
# Users
#=====================

get '/user/profile' do
  authenticate_user

  # All current challenges:
  @current_challenges = Challenge.where("end_time > ?", Time.now)

  # All current challenges for current user as creator:
  @current_challenges_creator = @current_challenges.where(user_id: current_user.id)
  @current_challenges.each do |challenge|
    # All current challenges for current user as voter:
    @current_challenges_voter = Voter.where('challenge_id = ? AND user_id = ?', challenge.id, current_user.id) 
  end
  
  # All expired challenges:
  @expired_challenges = Challenge.where("end_time < ?", Time.now)
  # All expired challenges for current user as creator:
  @expired_challenges_creator = @expired_challenges.where(user_id: current_user.id)
  @expired_challenges.each do |challenge|
    # All expired challenges for current user as voter:
    @expired_challenges_voter = Voter.where('challenge_id = ? AND user_id = ?', challenge.id, current_user.id) 
  end

  @all_challenges_created = Challenge.where(user_id: current_user.id)
  @successful_challenges = @all_challenges_created.where(successfulness: true)
  @unsuccesful_challenges = @all_challenges_created.where(successfulness: false)
  if current_user.login_token == session[:user_session]
    erb :'user/profile'
  else
    redirect '/index'
  end
end

get '/user/profile/:id' do
  @current_challenges_creator = current_user.records.where("role = ?",'creator')
  @current_challenges_voter = nil
  @expired_challenges = Challenge.where("start_time < ?", Time.current)
  @user = User.find(params[:id])
  @challenges = @user.challenges.order(end_time: :desc)
  erb :'user/profile'
end

#============
# challenges
#============

get '/challenges/new' do
  @user = current_user
  @challenge = Challenge.new
  erb :'challenges/new'
end

# save new challenge data to db
# TODO: add voters to challenge, and create records for voters
post '/challenges/create' do
  authenticate_user
  date_range = params[:daterange]
  capture_dates = /(.*) - (.*)/.match(date_range)
  start_time = DateTime.parse(capture_dates[1])
  end_time = DateTime.parse(capture_dates[2])
  voters = params[:voters]
  @challenge = Challenge.new(
    title: params[:title],
    description: params[:description],
    wager: params[:wager],
    start_time: start_time,
    end_time: end_time,
    user_id: current_user.id,
    complete: false
    )
  @challenge.save
  if @challenge.save
    voters.each do |voter|
      unless voter.to_i == current_user.id
        voter_record = Voter.new(
          challenge_id: @challenge.id,
          user_id: voter,
          accepted_invite: false,
          )
        voter_record.save
      end
    end
    redirect "/challenges/#{@challenge.id}"
  else
    erb :'/challenges/new'
  end
end


get '/challenges' do
  @current_challenges_creator = Challenge.where("end_time > ?", Time.current)
  @current_challenges_voter = nil
  @expired_challenges = Challenge.where("start_time < ?", Time.current)
  erb :'challenges/index'
end


get '/challenges/:id' do
  authenticate_user
  @challenge = Challenge.find(params[:id])
  @is_photo = File.exists?("./public/images/#{current_user.id}_proof_photo.jpg")
  @is_judgeday = Time.current > @challenge.end_time && @challenge.user_id = current_user.id

  @true_votes = Voter.where('challenge_id = ? AND vote = ?', @challenge.id, true).count

  @total_voters = Voter.where(challenge_id: @challenge.id).count

  @post_vote_result = (@true_votes >= @total_voters/2) ? true : false
  erb :'challenges/profile'
end

post '/challenge/save_proof' do
  @filename = "#{@user.id}_proof_photo.jpg"
  file = params[:file][:tempfile]
  File.open("./public/images/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
end
# STRETCH: creators can edit challenge

# get '/challenges/:id/edit' do
#   @user = current_user
#   @challenge = Challenge.find(params[:id])
#   erb :'challenges/new'
# end

error Sinatra::NotFound do
  erb :'errors/oops'
end
