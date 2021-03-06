#TODO fix everything that says challenge.creator
require_relative('./actions/profile')
require_relative('./actions/challenges')

# Homepage (Root path)

enable :sessions

helpers do

  def current_user
    if session.has_key?(:user_session)
      user = User.find_by_login_token(session[:user_session])
    else
      nil
    end
  end

  def all_current_challenges
    @current_challenges = Challenge.where("end_time > ?", Time.now)
  end

  def all_expired_challenges
    @expired_challenges = Challenge.where("end_time < ?", Time.now)
  end

end

def authenticate_user
  if current_user
    true
  else
    redirect 'index'
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
  erb :index
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
  @user = current_user
  all_current_challenges
  all_expired_challenges
  @current_challenges_voter = []
  @expired_challenges_voter = []
  @current_challenges_creator = @current_challenges.where(user_id: current_user.id)
  @expired_challenges_creator = @expired_challenges.where(user_id: current_user.id)

  # All current challenges for current user as voter:
  @current_challenges.each do |challenge|
    find = Voter.where(challenge_id: challenge.id, user_id: current_user.id)
    if find.exists?
      @current_challenges_voter << find[0]
    end
  end

  # All expired challenges for current user as voter:
  @expired_challenges.each do |challenge|
    find = Voter.where(challenge_id: challenge.id, user_id: current_user.id)
    if find.exists?
      @expired_challenges_voter << find[0]
    end
  end

  @all_challenges_created = Challenge.where(user_id: current_user.id)
  @successful_challenges = @all_challenges_created.where(successful: true).count
  @unsuccesful_challenges = @all_challenges_created.where(successful: false).count
  if current_user.login_token == session[:user_session]
    erb :'user/profile'
  else
    redirect '/index'
  end
end

get '/user/profile/:id' do
  authenticate_user
  all_current_challenges
  all_expired_challenges
  @current_challenges_voter = []
  @expired_challenges_voter = []
  @all_challenges_created = Challenge.where(user_id: params[:id])
  @successful_challenges = @all_challenges_created.where(successful: true).count
  @unsuccesful_challenges = @all_challenges_created.where(successful: false).count
  @current_challenges_creator = @current_challenges.where(user_id: params[:id])
  @expired_challenges_creator = @expired_challenges.where(user_id: params[:id])
  
  # All current challenges for current user as voter:
  @current_challenges.each do |challenge|
    find = Voter.where(challenge_id: challenge.id, user_id: params[:id])
    if find.exists?
      @current_challenges_voter << find[0]
    end
  end

  # All expired challenges for current user as voter:
  @expired_challenges.each do |challenge|
    find = Voter.where(challenge_id: challenge.id, user_id: params[:id])
    if find.exists?
      @expired_challenges_voter << find[0]
    end
  end

  @user = User.find(params[:id])
  @challenges = @user.challenges.order(end_time: :desc)
  erb :'user/profile'
end

#============
# challenges
#============

get '/challenges/new' do
  authenticate_user
  @user = current_user
  @challenge = Challenge.new
  erb :'challenges/new'
end

# save new challenge data to db
# TODO: add voters to challenge, and create records for voters
post '/challenges/create' do
  if params[:voters]
    @user = current_user
    date_range = params[:daterange]
    capture_dates = /(.*) - (.*)/.match(date_range)
    start_time = DateTime.parse(capture_dates[1]) + 4.hours
    end_time = DateTime.parse(capture_dates[2]) + 4.hours
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
      erb :'challenges/new'
    end
  else
    redirect "/challenges/new"
  end
end


get '/challenges' do
  authenticate_user
  @user = current_user
  all_current_challenges
  all_expired_challenges
  erb :'challenges/index'
end


get '/challenges/:id' do
  authenticate_user
  @user = current_user
  @challenge = Challenge.find(params[:id])
  @is_photo = File.exists?("./public/images/#{@challenge.id}_proof_photo.jpg")
  @is_creator = Challenge.where("user_id = ?", current_user).exists?
  @is_voter = Voter.where('challenge_id = ? AND user_id = ?',@challenge.id, current_user.id).exists?
  @has_not_voted = Voter.where(challenge_id: @challenge.id, user_id: current_user.id, vote: nil).exists?
  @is_judgeday = Time.current > @challenge.end_time
  @total_voters = Voter.where(challenge_id: @challenge.id).count
  @true_votes = Voter.where('challenge_id = ? AND vote = ?', @challenge.id, true).count
  @failed_votes = Voter.where('challenge_id = ? AND vote = ?', @challenge.id, false).count
  @all_votes_are_in = Voter.where(challenge_id: @challenge.id, vote: nil).length == 0
  @success = (@true_votes >= @failed_votes) ? true : false
  if @all_votes_are_in
    if @success
      @challenge.successful = true
    else
      @challenge.successful = false
    end
    @challenge.save
  end
  erb :'challenges/profile'
end

post '/challenges/:id' do
  @user = current_user
  @challenge = Challenge.find(params[:id])
  @current_voter = Voter.where('user_id = ? AND challenge_id = ?',current_user.id, @challenge.id)[0]
  if @current_voter
    if params[:vote_pass]
      @current_voter.vote = true
    elsif params[:vote_fail]
      @current_voter.vote = false
    end
    @current_voter.save
  else
    if params[:file]
      @filename = "#{@challenge.id}_proof_photo.jpg"
      file = params[:file][:tempfile]
      File.open("./public/images/#{@filename}", 'wb') do |f|
        f.write(file.read)
      end
    end
  end
  redirect "/challenges/#{params[:id]}"
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
