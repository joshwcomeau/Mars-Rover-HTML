require 'sinatra'



get "/" do
  
  @length = 9
  @height = 5
  erb :index
end