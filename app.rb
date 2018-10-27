require 'sinatra'  
require 'sinatra/activerecord' 
require 'sinatra/flash' 
set :database, 'sqlite3:bakery.sqlite3'  
require './models'

set :sessions, true

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
end

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

post "/login" do 
	if user = User.where(username: params[:username]).first
		if user.password == params[:password]
			session[:user_id] = user.id 
			flash[:notice] = "Successfully signed up"
			redirect "/products"
		else 
			flash[:notice] = "try again"
			redirect "/"
		end
	else 
		flash[:notice] = "try again"
		redirect "/"
	end
end



get "/products" do

	erb :products
end 