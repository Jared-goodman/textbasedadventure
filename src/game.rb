class Item
	
end

class Air < Item
	def identify
		return "nothing"
	end
	
	def getName
		return "nothing"
	end
end
class Sign < Item
	def initialize(message)
		@message = message
		@name = "sign"
		@identifier = "a sign"
	end
	
	def read
		puts "The sign reads, \"" + @message + "\""
	end
	
	def identify
		return @identifier
	end

	def getName
		return @name
	end
end

class NPC < Item
	def initialize(dialouge, name)
		@dialouge = dialouge
		@name = name
	end

	def speak
		puts @dialouge
	end
	
	def identify
		return @name
	end
	
	def getName
		return @name
	end
end
playerx = 10
playery = 1
MAP_HEIGHT = 20
MAP_WIDTH = 20

puts "Talk to Steve for instructions. (Hint: You are right next to him!)"
map = Array.new(MAP_HEIGHT) { Array.new(MAP_WIDTH) { Air.new } }
x = 0
y = 0

map[10][1] = NPC.new("Steve says: Hello! Welcome to the game! It seems you have figured out how to talk to people. There is a sign two units south of you. To move, type \"move \"south\". When you are close enough to see the sign, read it.", "steve")
map[10][3] = Sign.new("Good job!")
#finds a nearby object that matches the name. Returns coordinates in an array of [x, y]
def findObject(name, x, y, map)
#	puts map[x][y].identify
#	puts name
#	puts "finding " + name
	if map[x][y].identify.eql? name
#		puts x
#		puts y
		return [x, y]
	end
	return [x+1, y] if map[x+1][y].getName.eql? name
	return [x-1, y] if map[x-1][y].getName.eql? name
	return [x, y+1] if map[x][y+1].getName.eql? name
	return [x, y-1] if map[x][y-1].getName.eql? name
#	puts "returning nil"
	return nil
end

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
		start = input.index("talk to") + 8 if input.include? "talk to"
		start = input.index("speak to") + 9 if input.include? "speak to"
		name = input[start..input.length]
		puts "Attempting to talk to " + name
		coords = findObject(name, playerx, playery, map)
		puts coords
		map[coords[0]][coords[1]].speak unless coords == nil or not (map[coords[0]][coords[1]].is_a?(NPC))
		puts "You need to be near a player to speak to them." if coords == nil
		recognized = true
	end

	if input.include? "read"
		obj = input[input.index("read")+5..input.length]
		coords = findObject(obj, playerx, playery, map)
		if coords == nil 
			puts obj + " could not be found. Are you close enough to it?"
		else
			puts map[coords[0]][coords[1]].read
		end
		recognized = true
	end
#for debugging:
=begin
	
	if input.include? "find "
		name = input[input.index("find ") + 5..input.length]
		coords = findObject(name, playerx, playery, map)
		puts coords[0].to_s + " " + coords[1].to_s
		recognized = true
	end
=end	
	puts "unrecognized command" unless recognized == true
	puts "You are standing at " + map[playerx][playery].identify unless map[playerx][playery].identify.eql?("nothing")
	puts "To the north of you there is " + map[playerx][playery-1].identify unless playery == 0 or map[playerx][playery-1].identify.eql?("nothing")
	puts "To the west of you there is " + map[playerx-1][playery].identify  + " X: " + (playerx-1).to_s + " Y: " + playery.to_s unless playerx == 0 or map[playerx-1][playery].identify.eql?("nothing") 
	puts "To the south of you there is " + map[playerx][playery+1].identify unless playery == MAP_HEIGHT or map[playerx][playery+1].identify.eql?("nothing")
	puts "To the east of you there is " + map[playerx+1][playery].identify + " X: " + (playerx+1).to_s + " Y: " + playery.to_s unless playerx == MAP_WIDTH or map[playerx+1][playery].identify.eql?("nothing")
	#puts map
	gameloop(playerx, playery, map)
end

gameloop(playerx, playery, map)
