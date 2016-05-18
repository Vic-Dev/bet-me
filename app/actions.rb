# Homepage (Root path)
get '/' do
  erb :index
end

get '/profile/:id' do
  @user = User.find params[:id]
  # @challenges = Challenge.all <<<< to specific user
  erb :'user/profile'
end
