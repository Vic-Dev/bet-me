# Homepage (Root path)
enable :sessions

get '/' do
  erb :'testphoto/show_image'
end


get '/user/profile' do

end

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

#proof photo
post '/save_image' do

  @filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./public/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end

  erb :'testphoto/show_image'
end
