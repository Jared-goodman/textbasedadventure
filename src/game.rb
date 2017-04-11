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
	end
	
	def read
		puts "The sign reads, \"" + @message + "\""
	end
	
	def identify
		return "a sign that reads \"" + @message + "\""
	end
end

playerx = 10
playery = 0

puts "Type \"READ\" for instructions."
map = Array.new(20, Array.new(20, Item))
x = 0
y = 0
while(x < 20)
	while(y<20)
		map[x][y] = Air.new
		y = y + 1
	end
	y = 0
	x = x + 1
end

map[10][1] = Sign.new("Welcome to [insert name here that I haven't thought of yet but it's pretty kewl]!")
map[1][1].read


def gameloop (playerx, playery, map)
	input = gets.chomp.downcase
	
	if input.eql? "move north"
		if playery != 0
			playery = playery - 1
			puts "You have moved north." 
		else
			puts "You can\'t do that, you are at the top of the map."
		end
	end
	if input.eql? "move south"
		if playery != 20
			playery = playery + 1
			puts "You have moved south."
		else
			puts "You can\'t do that, you are at the top of the map."
		end
	end

	if input.eql? "move west"
		if playerx != 0
			playerx = playerx - 1
		else
			puts "You can\'t do that, you are at the westmost part of the map."
		end
	end
	
	if input.eql? "move east"
		if playery != 20
			playerx = playerx + 1
		else
			puts "You can\'t do that, you are at the eastmost part of the map."
		end
	end
	
	puts "To the north of you there is " + map[playerx][playery+1].identify unless playery == 20 or map[playerx][playery+1].identify.eql?("nothing")
	puts "To the west of you there is " + map[playerx-1][playery].identify unless playerx == 0 or map[playerx-1][playery].identify.eql?("nothing") 
	puts  "To the south of you there is " + map[playerx][playery-1].identify unless playery == 0 or map[playerx][playery-1].identify.eql?("nothing")
	puts "To the east of you there is " + map[playerx+1][playery].identify unless playerx == 20 or map[playerx+1][playery].identify.eql?("nothing")

end
while true
	gameloop(playerx, playery, map)
end
