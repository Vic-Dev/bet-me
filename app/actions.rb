require_relative('./actions/profile')
require_relative('./actions/challenges')

# Homepage (Root path)
get "/" do
  erb :index
end
