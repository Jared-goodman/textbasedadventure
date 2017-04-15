class Item
	def getName
		return @name
	end
	def identify
		return @identifier
	end
	def liftable?
		return false
	end
	def passable?
		return true
	end
	
	def getAttack
		return 0
	end
end

class Tool < Item
	def initialize(name, identifier, attack)
		@name = name
		@identifier = identifier
		@attack = attack
	end

	def liftable?
		return true
	end

	def getAttack
		return @attack
	end
end

class Air < Item
	def initialize
		@name = "nothing"
		@identifier = "nothing"
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
	
end

class Door < Item
	def initialize (opened)
		@opened = opened
		@name = "door"
		@identifier = "a door"
	end
	
	def passable?
		return @opened
	end

	def open
		@opened = true
		puts "The door has been opened."
	end

	def close
		@opened = false
		puts "The door has been closed."
	end
end

class NPC < Item
	def initialize(dialouge, name)
		@dialouge = dialouge
		@name = name
		@identifier = name
	end

	def speak
		puts @dialouge
	end
	
end

class Wall < Item
	def initialize
		@name = "wall"
		@identifier = "a wall"
	end

	
	def passable?
		return false
	end
end

#Trivia question for monster bonus attack.
class Question
	def initialize(question, answer)
		@question = question
		@answer = answer
	end
	def checkAnswer(answer)
		toReturn = answer.downcase.eql? @answer.downcase
		if toReturn
			puts "Correct! You get two attacks this turn."
		else
			puts "Wrong! The answer was " + @answer
		end
	end

	def getQuestion
		return @question
	end
end

class Monster < Item
	def initialize(name, hp, attack, reward, question)
		@name = name
		@hp = hp
		@attack = attack
		@question = question
		@reward = reward
	end

	def getAttack()
		return @attack
	end

	def heal(x)
		@hp = @hp + x
	end

	def hurt(x)
		@hp = @hp - x
	end
	def getHealth
		return @hp
	end
	def getQuestion
		return @question
	end

	def isDead?
		return @hp<=0
	end
	def identify
		return "a monster"
	end
	def getReward
		return @reward
	end

end

#Used only for battling and inventory. Does not show up on map.
class Player
	def initialize
		@inventory = []
		@hp = 100
		
	end
	def heal(x)
		@hp = @hp + x
	end
	
	def hurt(x)
		@hp = @hp - x
	end

	def give(x)
		@inventory.push(x)
	end

	def getInventory
		return @inventory
	end
	
	def getHealth
		return @hp
	end
	
	def isDead?
		return @hp<=0
	end
	def getName
		return "you"
	end
end

def battle (m, p)
	puts "You are now in a battle with the monster " + m.getName + "!"
	return battleLoop(m, p, 0)
end

def touching?(playerx, playery, map, obj)
	return true if playerx != 0 and map[playerx-1][playery].identify.eql? obj
	return true if playerx != 20 and map[playerx+1][playery].identify.eql? obj
	return true if playery != 0 and map[playerx][playery-1].identify.eql? obj
	return true if playery != 20 and map[playerx][playery+1].identify.eql? obj
	#puts "touching method returned false"
	return false
end

#Battles monster m with player p. Returns 0 if monster won, returns 1 if player won.
def battleLoop (m, p, round)
	puts "Your health: " + p.getHealth.to_s + " Monster health: " + m.getHealth.to_s
	if p.getInventory.length != 0
		for x in 0..p.getInventory.length-1
			puts "Item " + (x+1).to_s + ": " + (p.getInventory[x].identify) + "(+" + (p.getInventory[x].getAttack.to_s) + " damage)"
			
        	end
		puts "Please select an item by typing it's number."
		weapon = p.getInventory[gets.chomp.to_i-1].getAttack
		bonus = false
	else
		"There is nothing in your inventory to use as a weapon.."
		weapon = 0
	end
	if round == 0
		puts "If you get this trivia question right, you get a bonus attack."
		puts m.getQuestion.getQuestion
		if m.getQuestion.checkAnswer(gets.chomp)
			bonus = true
		end	
	end

	#MonsterDamage is damage dealt BY monster, playerDamage is damage dealt TO monster.
	monsterDamage = (m.getAttack-rand(m.getAttack))
	playerDamage = (10+weapon-rand(10))
	if bonus
		playerDamage = playerDamage*2
	end
	puts "Damage dealt by monster: " + monsterDamage.to_s
	puts "Damage dealt to monster: " + playerDamage.to_s
	p.hurt(monsterDamage)
	puts "Your health: " + p.getHealth.to_s
	m.hurt(playerDamage)
	puts "Monster health: " + m.getHealth.to_s
	if p.isDead?
		puts "You died!"
		return 0
	end

	if m.isDead?
		puts "You win!"
		return 1
	end
	return battleLoop(m, p, round + 1)
	
end 
playerx = 10
playery = 1
MAP_HEIGHT = 20
MAP_WIDTH = 20
puts "Talk to Steve for instructions. (Hint: You are right next to him!)"
map = Array.new(MAP_HEIGHT) { Array.new(MAP_WIDTH+1) { Air.new } }
x = 0
y = 0

player = Player.new
map[10][1] = NPC.new("Steve says: Hello! Welcome to the game! There is a sign two units south of you. To move, type \"move \"south\". When you are close enough to see the sign, read it.", "steve")
map[10][3] = Sign.new("Good job! Can you open the door behind this sign?")
map[10][7] = Sign.new("Behind the next door is a monster. Battling the monster will automatically start once you get close to it. To help you, there is a sharp rock directly to the east of this sign. Pick it up using the \"Pick up __\" command.")
map[11][6] = Tool.new("rock", "a rock", 3)

for i in 0..MAP_WIDTH-1
#	puts "creating a wall at " + i.to_s
	map[i][4] = Wall.new
	map[i][7] = Wall.new
end
map[10][4] = Door.new(false)
map[10][7] = Door.new(false)
#name, hp, attack, reward, question

map[10][8] = Monster.new("Ed The Monster",  80, 5, Tool.new("sword", "a sword", 10), Question.new("How many suns are there in the sky on a clear day?", "1"))
#finds a nearby object that matches the name. Returns coordinates in an array of [x, y]
def findObject(name, x, y, map)
#	puts map[x][y].identify
#	puts name
#	puts "finding " + name
	if map[x][y].getName.eql? name
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

def findObjectIdentifier(name, x, y, map)
	 if map[x][y].getName.eql? name
#               puts x
#               puts y
                return [x, y]
        end
        return [x+1, y] if map[x+1][y].identify.eql? name
        return [x-1, y] if map[x-1][y].identify.eql? name
        return [x, y+1] if map[x][y+1].identify.eql? name
        return [x, y-1] if map[x][y-1].identify.eql? name
#       puts "returning nil"
        return nil
end

def gameloop (playerx, playery, map, player)
	puts "Your x: " + playerx.to_s + ". Your y: " + playery.to_s
	puts "Your inventory:" unless player.getInventory.length == 0
	for x in 0..player.getInventory.length-1
		puts "Item " + (x+1).to_s + ": " + player.getInventory[x].identify
	end

	input = gets.chomp.downcase
	recognized = false
#	I need to look like im typing in science class so im typing this comment the instruments carried by radiosonds something something temperature something something direction for x in 0..MAP_HEIGHT
#		for y in 0..MAP_WIDTH
	#		puts "X: " + x.to_s + " Y: " + y.to_s + " " + map[x][y].getName
#		end
#	end
 
	if input.eql? "move north"
		if playery != 0 and map[playerx][playery-1].passable?
			playery = playery - 1
			puts "You have moved north." 
		else
			puts "You can\'t do that, you are at the top of the map." if playery == 0
			puts map[playerx][playery-1].identify + " blocks your path." unless playery == 0
		end
		recognized = true
	end
	if input.eql? "move south"
		if playery != MAP_HEIGHT and map[playerx][playery+1].passable?
			playery = playery + 1
			puts "You have moved south."
		else
			puts "You can\'t do that, you are at the top of the map." if playerx == MAP_HEIGHT
			puts map[playerx][playery+1].identify + " blocks your path." unless playerx == MAP_HEIGHT
		end
		recognized = true
	end

	if input.eql? "move west"
		if playerx != 0 and map[playerx-1][playery].passable?
			playerx = playerx - 1
		else
			puts "You can\'t do that, you are at the westmost part of the map." if playerx == 0
			puts map[playerx-1][playery].identify + " blocks your path." unless playerx == 0
		end
		recognized = true
	end
	
	if input.eql? "move east"
		if playery != MAP_WIDTH
			playerx = playerx + 1
		else
			puts "You can\'t do that, you are at the eastmost part of the map." if playery == MAP_WIDTH
			puts map[playerx-1][playery].identify + " blocks your path" unless playery == MAP_WIDTH 
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
		if coords == nil or map[coords[0]][coords[1]].methods.include? "read"
			puts obj + " either could not be found or doesn't have text. Are you close enough to it?"
		else
			map[coords[0]][coords[1]].read
		end
		recognized = true
	end

	if input.include? "open"
		obj = input[input.index("open")+5..input.length]
                coords = findObject(obj, playerx, playery, map)
                if coords == nil or map[coords[0]][coords[1]].methods.include? "open"
                        puts obj + " either could not be found or opened. Are you close enough to it?"
                else
                        map[coords[0]][coords[1]].open
                end
                recognized = true
	end

	if input.include? "close"
                obj = input[input.index("close")+6..input.length]
                coords = findObject(obj, playerx, playery, map)
                if coords == nil or map[coords[0]][coords[1]].methods.include? "close"
                        puts obj + " either could not be found or close. Are you close enough to it?"
                else
                        puts map[coords[0]][coords[1]].close
                end
                recognized = true
        end

	if input.include? "pick up"
		obj = input[input.index("pick up")+8..input.length]
		coords = findObject(obj, playerx, playery, map)
		if coords != nil
			if map[coords[0]][coords[1]].liftable?
				player.give(map[coords[0]][coords[1]])
				map[coords[0]][coords[1]] = Air.new
				puts "Picked up object succesfully."
			else
				puts "Object is too heavy to lift!"
			end
		else
			puts obj + " could not be found. Are you close enough to it?"
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
	if touching?(playerx, playery, map, "a monster")
#		puts "touching monster"
		obj = findObjectIdentifier("a monster", playerx, playery, map)
		if obj != nil
			#puts "obj is " + obj.to_s
			winner = battle(map[obj[0]][obj[1]], player)
			if winner == 0
				puts "You died!"
				abort
			end
#			puts map[obj[0]][obj[1]].getName
#			puts map[obj[0]][obj[1]].getReward.getName
			puts map[obj[0]][obj[1]].getName + " dropped " + map[obj[0]][obj[1]].getReward.identify + "!"
			map[obj[0]][obj[1]] = map[obj[0]][obj[1]].getReward
		end
	end
	puts "unrecognized command" unless recognized == true
	puts "You are standing at " + map[playerx][playery].identify unless map[playerx][playery].identify.eql?("nothing")
	puts "To the north of you there is " + map[playerx][playery-1].identify unless playery == 0 or map[playerx][playery-1].identify.eql?("nothing")
	puts "To the west of you there is " + map[playerx-1][playery].identify  unless playerx == 0 or map[playerx-1][playery].identify.eql?("nothing") 
	puts "To the south of you there is " + map[playerx][playery+1].identify unless playery == MAP_HEIGHT or map[playerx][playery+1].identify.eql?("nothing")
	puts "To the east of you there is " + map[playerx+1][playery].identify unless playerx == MAP_WIDTH or map[playerx+1][playery].identify.eql?("nothing")
	#puts map
	gameloop(playerx, playery, map, player)
end

gameloop(playerx, playery, map, player)
