require 'sinatra'  
require 'sinatra/activerecord' 
require 'sinatra/flash' 
set :database, 'sqlite3:bakery.sqlite3'  
require './models'
require 'sendgrid-ruby'

include SendGrid

set :sessions, true

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
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

post "/logout" do 
	session[:user_id] = nil
	puts 'whatever'
	redirect "/thank"
end

get '/guests' do 
	@users = User.all
	erb :guests
end

get "/guests/:id" do
	@user = User.find_by_id(params[:id])
	erb :guest
end



class Cookies
	attr_accessor :name, :price, :url
	def initialize(name, price, url)
		@name = name
		@price = price
		@url = url
	end

end
	
	class Muffins
	end
	class Cholocate
	end


get "/products" do
	@c1 = Cookies.new('cholocate cookie', 6, "http://hostthetoast.com/wp-content/uploads/2014/10/The-Best-Chewy-Cafe-Style-Chocolate-Chip-Cookies-5.jpg")
	@c2 = Cookies.new('vanilla cookie', 5, "https://d1doqjmisr497k.cloudfront.net/-/media/mccormick-us/recipes/mccormick/v/800/vanilla-sugar-cookies.ashx?vd=20180710T052047Z&hash=24F6692C9F8265CFE313D4B876956B35C60E44F1")
	@c3 = Cookies.new('peanut cookie', 5, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGprV4q51KFpPN7dsykjWp9jKUSXfLraoDeOaZSyNfP_Fc5W3M")
	@cookies = [@c1, @c2, @c3]
	erb :products
end 

get "/products/cookies" do 
	erb :cookies
end

get "/products/muffins" do
	erb :muffins
end

get "/products/cholocate" do
	erb :chocoloate
end


get "/contact" do
	erb :contact
end

post "/mail" do
	from = Email.new(email: params[:inputEmail])
	to = Email.new(email: 'ogidan@abv.bg')
	subject = params[:inputSubject]
	content = Content.new(type: 'text/plain', value: params[:inputText])
	mail = Mail.new(from, subject, to, content)

sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
response = sg.client.mail._('send').post(request_body: mail.to_json)
puts response.status_code
puts response.body
puts response.headers
	redirect "/thank"
end

get '/thank' do
	erb :thank
end








