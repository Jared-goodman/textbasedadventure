class Item
	
end

class Air < Item
	def identify
		return "nothing"
	end
end
class Sign < Item
	def initialize(message)
		@message = message
		@name = "sign"
	end
	
	def read
		puts "The sign reads, \"" + @message + "\""
	end
	
	def identify
		return "a sign"
	end
end

class NPC < Item
	def initialize(dialouge, name)
		@dialouge = dialouge
		@name = name
	end

	def speak
		puts dialouge
	end
	
	def identify
		return @name
	end
end
playerx = 10
playery = 1
MAP_HEIGHT = 20
MAP_WIDTH = 20

puts "Type \"Read\" for instructions."
map = theMap = Array.new(MAP_HEIGHT) { Array.new(MAP_WIDTH) { Air.new } }
x = 0
y = 0

map[10][1] = Sign.new("Welcome to [insert name here that I haven't thought of yet but it's pretty kewl]!")

def gameloop (playerx, playery, map)
	puts "Your x: " + playerx.to_s + ". Your y: " + playery.to_s
	input = gets.chomp.downcase
	recognized = false

	if input.eql? "move north"
		if playery != 0
			playery = playery - 1
			puts "You have moved north." 
		else
			puts "You can\'t do that, you are at the top of the map."
		end
		recognized = true
	end
	if input.eql? "move south"
		if playery != MAP_HEIGHT
			playery = playery + 1
			puts "You have moved south."
		else
			puts "You can\'t do that, you are at the top of the map."
		end
		recognized = true
	end

	if input.eql? "move west"
		if playerx != 0
			playerx = playerx - 1
		else
			puts "You can\'t do that, you are at the westmost part of the map."
		end
		recognized = true
	end
	
	if input.eql? "move east"
		if playery != MAP_HEIGHT
			playerx = playerx + 1
		else
			puts "You can\'t do that, you are at the eastmost part of the map."
		end
		recognized = true
	end
	
	if input.include? "talk to" or input.include? "speak to"
		start = input.index "talk to" if input.include? "talk to"
		start = input.index "speak to" if input.include? "speak to"
		name = input[start + 1..input.length]
		puts "asked to speak to " + name
		recognized = true
	end
	puts "unrecognized command" unless recognized == true
	puts "You are standing at " + map[playerx][playery].identify unless map[playerx][playery].identify.eql?("nothing")
	puts "To the north of you there is " + map[playerx][playery-1].identify unless playery == 0 or map[playerx][playery+1].identify.eql?("nothing")
	puts "To the west of you there is " + map[playerx-1][playery].identify  + " X: " + (playerx-1).to_s + " Y: " + playery.to_s unless playerx == 0 or map[playerx-1][playery].identify.eql?("nothing") 
	puts "To the south of you there is " + map[playerx][playery+1].identify unless playery == MAP_HEIGHT or map[playerx][playery-1].identify.eql?("nothing")
	puts "To the east of you there is " + map[playerx+1][playery].identify + " X: " + (playerx+1).to_s + " Y: " + playery.to_s unless playerx == MAP_WIDTH or map[playerx+1][playery].identify.eql?("nothing")
	#puts map
	gameloop(playerx, playery, map)
end

gameloop(playerx, playery, map)
