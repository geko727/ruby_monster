require 'rubygems'
require 'sinatra'

set :sessions, true
X = 60 

helpers do 
	def probability
		a = 100
		b = rand(a)
		if b <= X
			@c = 1
			#battle
		else 
			@c = 2
			#nothing
		end
		@c
	end
    
    def imagen
    	image = session[:friend_name]
    	"<img src='/images/#{image}.png' style='width: 250px; height: 200px; margin: 5px 0px 5px 50px;'/>"
   	end

   	def enemy_level(a)
		if a == 1
			prng = Random.new
			a = prng.rand(1..3)
			@lev = a
		elsif a == 2 
			prng = Random.new
			a = prng.rand(1..4)
			@lev = a
		elsif a == 10 
			prng = Random.new
			a = prng.rand(8..10)
			@lev = a
		else
			prng = Random.new
			min = a - 2
			max = a + 2
			a = prng.rand(min..max)
			@lev = a 
		end
		@lev
	end


   	def create_enemy
   		session[:enemy_name] = "Gengar"
   		a = session[:friend_level]
   		enemy_level(a)
   		session[:enemy_level] = @lev
		session[:enemy_special] = "EvilShadow"
		session[:enemy_health] = 10
   	end
end

get "/" do
	erb :user
end

post "/new_player" do
	if params[:player_name].empty?
		@error = "Name is required"
		halt erb(:user)
	end
	session[:player_name] = params[:player_name]
	redirect "/welcome"
end
 
get "/welcome" do
	erb :welcome
end

get "/adventure" do
	erb :adventure
end

post "/create_friend" do 
	session[:friend_name] = params[:friend_name]
	session[:friend_level] = 1
	session[:friend_special] = params[:friend_special]
	session[:friend_health] = 10
	redirect "/adventure"
end

post "/adventure" do 
	erb :adventure
end

post "/validation" do 
	probability
	if @c == 1 
		redirect "battle"
	elsif @c == 2
		redirect "nothing"
	end
end

get "/battle" do 
	create_enemy
	erb :battle
end

get "/nothing" do
	erb :nothing
end



