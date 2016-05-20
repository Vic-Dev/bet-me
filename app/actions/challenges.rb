# shows create challenge form
# get '/challenges/create' do
#   @challenge = Challenge.new
#   erb :'challenges/create'
# end

# # save new challenge data to db
# post '/challenges/create' do 
#   @challenge = Challenge.new(
#     title: params[:title],
#     description: params[:description],
#     wager: params[:wager],
#     start_time: params[:start_time],
#     end_time: params[:end_time]
#     )
#   @record = Record.new(
#     user_id: current_user.id,
#     challenge_id: @challenge.id,
#     role: "creator",
#     is_active: true,
#     is_completed: false,
#     vote_result: nil
#   )
#   redirect "/profile/:id"
# end