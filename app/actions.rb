# Homepage (Root path)
get "/" do
  erb :index
end

get '/profile/:id' do
  @user = User.find(params[:id])
  @challenges = @user.challenges
  erb :'user/profile'
end
