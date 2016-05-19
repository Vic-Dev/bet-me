# Homepage (Root path)
enable :sessions








get '/' do
  redirect '/profile'
end

get '/index' do
  erb :'/index'
end
