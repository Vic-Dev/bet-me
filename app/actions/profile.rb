get '/profile/:id' do
  @user = User.find(params[:id])
  @challenges = @user.challenges
  erb :'user/profile'
end