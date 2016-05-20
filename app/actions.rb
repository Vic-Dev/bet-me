# Homepage (Root path)
get "/" do
  erb :index
end

# get '/profile/:id' do
#   @user = User.find(params[:id])
#   @challenges = @user.challenges
#   erb :'user/profile'
# end

# shows create challenge form
get '/challenges/create' do
	@challenge = Challenge.new
	erb :'challenges/create'
end

# save new challenge data to db
post '/challenges/create' do 
	new_friend = params[:invite_friend]
	@challenges = Challenge.new(
		title: params[:title],
		description: params[:description],
		wager: params[:wager],
		start_time: params[:start_time],
		end_time: params[:end_time]

		)
	# if @challenges.save
	# 	redirect "/profile/:id"
	# else 
	# 	redirect "/challenges/create"
	# end
end






