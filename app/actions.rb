# Homepage (Root path)
enable :sessions

get '/user/profile' do

end

get '/user/profile/:id' do
  @user = User.find(params[:id])
  @challenges = @user.challenges.order(end_time: :desc)
  erb :'user/profile'
end

#============
# challenges
#============

get '/challenges'
  @current_challenges = Challenge.where("end_time > ?", Time.current)
  @expired_challenges = Challenge.where("start_time < ?", Time.current)
end

get '/challenges/:id' do
  @challenge = Challenge.find(params[:id])
  erb :'challenges/profile'
end
