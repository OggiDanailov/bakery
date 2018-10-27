require 'sinatra'  
require 'sinatra/activerecord'  
set :database, 'sqlite3:bakery.sqlite3'  
require './models'


get "/" do 	
	erb :home
end

post "/signup" do
	username = params[:username]
	password = params[:password]
	user = User.new(username: username, password: password)
	if user.save
		redirect "/products"
	else 
		erb :home
	end  
end

get "/products" do

	erb :products
end 