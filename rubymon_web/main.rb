require 'rubygems'
require 'sinatra'

set :sessions, true
X = 60 

helpers do 
	def move_probability
		level_probability = session[:enemy_level] - session[:friend_level]
		if level_probability == 2
			@j = 60
			proba_stand(@j)
		elsif level_probability == 1
			@j = 40
			proba_stand(@j)
		elsif level_probability <= 0 
			@j = 20
			proba_stand(@j)
		end
			@i
	end

	def proba_stand(h)
		a = 100
		b = rand(a)
		if b <= h 
			@i = 1
			#battle
		else 
			@i = 2
			#nothing
		end
		@i
	end

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

before do 
	@enemy_turn = false
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

post "/attack" do 
	#move_probability
	@i = 2
	if @i == 1
		@miss = "#{session[:friend_name]} missed the attack"
		@enemy_turn = true
		erb :battle, layout: false
		#@success = "#{@friend.name} tried to attack"
		#@error = "#{@friend.name} missed this turn"
	 		#@evil_turn += 1
			#	enemy_action
	elsif @i == 2
		
		if @enemy_defense 
			prng = Random.new
			e = prng.rand(1..2)
			if e == 1 
				@hit = "#{session[:enemy_name]}'s hp - 1"
				session[:enemy_health] -= 1
				if @enemy.hp <= 0
					redirect "/win"
				end
				@enemy_turn = true
				erb :battle, layout: false
			else 
				miss = "#{session[:friend_name]}'s attack don't have effect"
				@enemy_turn = true
				erb :battle, layout: false
			end
			@enemy_defense = false
		end
		@hit = "#{session[:enemy_name]}'s hp - 2"
		session[:enemy_health] -= 2
		if session[:enemy_health] <= 0 
			redirect "/win"
		end
		@enemy_turn = true
		erb :battle, layout: false
	end
	
	#puts "#{@friend.name} attacks!!!"
		#session[:enemy_health] -= 2
		#if @enemy.hp <= 0
		#	win
		#end
		#puts "#{@enemy.name}'s hp = #{@enemy.hp}"
		#@evil_defense = false
		#@evil_turn += 1
		#enemy_action
		#erb :battle, layout: false
end

post "/enemy_turn" do 
	prng = Random.new
		#f = prng.rand(1..3)
		f = 2
		if f == 1
			move_probability
			if @i == 1
				@hit = "#{session[:enemy_name]} tried to attack, #{session[:enemy_name]} missed the turn"
				erb :battle, layout: false
			elsif @i == 2
				redirect "/enemy_attack"
			end
		elsif f == 2
			move_probability
			if @i == 1
				@hit = "#{session[:enemy_name]} tried to defense, #{session[:enemy_name]} missed the turn"
				erb :battle, layout: false
			elsif @i == 2
				redirect "/enemy_defense"
			end
		elsif f == 3
			move_probability
			if @i == 1
				@hit = "#{session[:enemy_name]} tried to use #{session[:enemy_special]}, #{session[:enemy_name]} missed the turn"
				erb :battle, layout: false
			elsif @i == 2
				redirect "/enemy_special"
			end
		end
end

get "/enemy_attack" do
	move_probability
	if @i == 1
		@hit = "#{session[:enemy_name]} use tackle, #{session[:enemy_name]} missed the attack"
		@enemy_turn = false
		erb :battle, layout: false
		#@success = "#{@friend.name} tried to attack"
		#@error = "#{@friend.name} missed this turn"
	 		#@evil_turn += 1
			#	enemy_action
	elsif @i == 2
		@miss = "#{session[:enemy_name]} use tackle, #{session[:friend_name]}'s hp - 2"
		session[:friend_health] -= 2
		if session[:friend_health] <= 0 
			redirect "/lose"
		end
		@enemy_turn = false
		erb :battle, layout: false
	end
	
end

get "/win" do 
	erb :win
end

get "/lose" do
	erb :lose
end

post "/special" do 
	move_probability
	if @i == 1
		@miss = "#{session[:friend_name]} missed the attack"
		@enemy_turn = true
		erb :battle, layout: false
		#@success = "#{@friend.name} tried to attack"
		#@error = "#{@friend.name} missed this turn"
	 		#@evil_turn += 1
			#	enemy_action
	elsif @i == 2
		@hit = "#{session[:enemy_name]}'s hp - 4"
		session[:enemy_health] -= 4
		if session[:enemy_health] <= 0 
			redirect "/win"
		end
		@enemy_turn = true
		erb :battle, layout: false
	end
end

post "/defense" do 
	@friend_defense = true
	@enemy_turn = true
	erb :battle, layout: false
end

get "/enemy_defense" do 
	@miss = "#{session[:enemy_name]} use defense"
	@enemy_turn = false
	@enemy_defense = true
	erb :battle, layout: false
end

get "/enemy_special" do 
	move_probability
	if @i == 1
		@hit = "#{session[:enemy_name]} use #{session[:enemy_special]}, #{session[:enemy_name]} missed the attack"
		erb :battle, layout: false
		#@success = "#{@friend.name} tried to attack"
		#@error = "#{@friend.name} missed this turn"
	 		#@evil_turn += 1
			#	enemy_action
	elsif @i == 2
		@miss = "#{session[:enemy_name]} use #{session[:enemy_special]}, #{session[:friend_name]}'s hp - 4"
		session[:friend_health] -= 4
		if session[:friend_health] <= 0 
			redirect "/lose"
		end
		erb :battle, layout: false
	end   
end	
