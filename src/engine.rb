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
	def passable?(player)
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
	
	def passable?(player)
		return @opened
	end

	def open
		@opened = true
		puts "The door has been opened."
		return nil
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

class PowerUp < Item
	def passable?(p)
		return true
	end

	def drink(p)
	end
	def liftable?
		return true
	end
end

class JumpBoost < PowerUp
	
	def initialize(intensity)
		@intensity = intensity
		@name = "jump boost potion"
		@identifier = "a jump boost potion (level " + @intensity.to_s + " intensity)"
		#puts "Initialized potion" + self.identify
	end

	def drink(p)
		p.jumpBoost(@intensity)
		puts "You drink the potion. You can now jump " + p.getJump.to_s + " meters high."
	end
	
end

class Wall < Item
	def initialize(height)
		@name = "wall"
		@identifier = "a wall that is " + height.to_s + " meters tall" 
		@height = height
	end

	
	def passable?(p)
		return p.getJump >= @height
	end
end

class Chest < Item
	def initialize(items)
		@items = items
		@identifier = "a chest"
		@name = "chest"
	end

	def printItems
		puts "The chest contains:"
		for x in 0..@items.length-1
			puts "Item " + (x+1).to_s + ": " + @items[x].identify
		end
	end
	
	def takeItem(x)
		temp = @items[x]
		@items.delete_at(x)
#		puts "In takeitem method. Taking " + temp.identify
#		puts @items[x].identify
		return temp
	end

	def open
		return privateOpen([])
	end

	def privateOpen(ar)
		chars = "1234567890"
                printItems
                puts "Select an item or type \"close\" to close the chest."
                input = gets.chomp
                if input.eql? "close"
                       # puts "In close block. First item of ar is " + ar[0].identify
                        return ar
               end
                for x in input.chars
                        if not chars.include? x
                                puts "Error! Please type a number."
                                return privateOpen(ar)
                        end
                end
                parsed = input.to_i-1
                ar.push(takeItem(parsed))
	#	puts "just ran ar.push; ar[0] is now " + ar[0].identify
	#	if ar.length == 2
	#		puts ar[1].identify
	#	else
	#		puts "len != 2"
	#	end
                toReturn = privateOpen(ar)
	#	puts toReturn[0].identify
		return toReturn
	end
end

#Trivia question for monster bonus attack.
class Question
	def initialize(question, answer)
		@question = question
		@answer = answer
		@checked = false
	end
	def checkAnswer(answer)
		toReturn = answer.downcase.eql? @answer.downcase
		if toReturn
			puts "Correct! You get two attacks this turn."
		else
			puts "Wrong! The answer was " + @answer
		end
		@checked = true
	end

	def getQuestion
		return @question
	end

	def getChecked
		return @checked
	end
end

class Note < Item
        def initialize(message)
                @message = message
                @name = "note"
                @identifier = "a note that says \"" + @message + "\""
        end

        def read
                puts "The note reads, \"" + @message + "\""
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
	def useQuestion
		for x in @question
			if not x.getChecked
				puts "If you get this trivia question right, you get a bonus attack!"
				puts x.getQuestion
				return x.checkAnswer(gets.chomp)
				break
			end
			return false
		end
	end

end


#Used only for battling and inventory. Does not show up on map.
class Player
	def initialize
		@inventory = []
		@hp = 100
		@jump = 2
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

	def getJump
		return @jump
	end

	def jumpBoost(x)
		@jump = @jump + x
		return @jump
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
def getnum(inventory)
	input = gets.chomp
	rope = "0123456789"
	for x in 0..input.length-1
		if not rope.include?input[x]
			puts "Please type in a number."
			return getnum(inventory)
		end
		if input.to_i>inventory.length-1 or input.to_i<=0
			puts "Please select an item from the list."
		end
	end
	return input
end
#Battles monster m with player p. Returns 0 if monster won, returns 1 if player won.
def battleLoop (m, p, round)
	puts "Your health: " + p.getHealth.to_s + " Monster health: " + m.getHealth.to_s
	if p.getInventory.length != 0
		for x in 0..p.getInventory.length-1
			puts "Item " + (x+1).to_s + ": " + (p.getInventory[x].identify) + "(+" + (p.getInventory[x].getAttack.to_s) + " damage)"
			
        	end
		puts "Please select an item by typing it's number."
		
		weapon = p.getInventory[getnum(p.getInventory).to_i-1].getAttack
		bonus = false
	else
		"There is nothing in your inventory to use as a weapon.."
		weapon = 0
	end
	bonus = m.useQuestion()
	#monsterDamage is damage dealt BY monster, playerDamage is damage dealt TO monster.
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

#Gets the numbers after a line, returns an array. For example, if the thrid line is "wall 6", getNums(3, fileName) would return [6].

def getNums(line, fileName)
	text = IO.readlines(fileName)[line] + " "
	text = text[text.index(" ")+1..text.length]
	#puts text
	toReturn = []
	#puts toReturn[0]
	while text.include?(" ")
		toReturn.push(text[0..text.index(" ")].to_i)
		text = text[text.index(" ")+1..text.length]
		#puts text	
	end
	return toReturn
end

#The following comment is so that I can do ^W in nano and find this spot quickly : asdg

puts "Enter file name (e.g. example.txtgame)"
fileName = gets.chomp
puts "Interpeting code..."
mapArray = getNums(0, fileName)
MAP_HEIGHT = mapArray[0]
MAP_WIDTH = mapArray[1]
#puts MAP_HEIGHT
#puts MAP_WIDTH
map = [[]]
for h in 0..MAP_HEIGHT
	for w in 0..MAP_WIDTH
		map[h].push(Air.new)
	end
	map.push([])
end
player = Player.new
playerArray = getNums(1, fileName)
playerx = playerArray[0]
playery = playerArray[1]
def findObject(name, x, y, map)
#	puts map[x][y].identify
#	puts name
#	puts "finding " + name
	if map[x][y].getName.eql? name
#		puts x
#		puts y
		return [x, y]
	end
	return [x+1, y] if map[x+1][y].getName.include? name
	return [x-1, y] if map[x-1][y].getName.include? name
	return [x, y+1] if map[x][y+1].getName.include? name
	return [x, y-1] if map[x][y-1].getName.include? name
#	puts "returning nil"
	return nil
end

def findObjectFromInventory(name, p)
#	puts "finding \"" + name + "\" from inventory..."
	for x in 0..p.getInventory.length
		return x if p.getInventory[x].identify.include?name
	end

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
		if playery != 0 and map[playerx][playery-1].passable?(player)
			playery = playery - 1
			puts "You have moved north." 
		else
			puts "You can\'t do that, you are at the top of the map." if playery == 0
			puts map[playerx][playery-1].identify + " blocks your path." unless playery == 0
		end
		recognized = true
	end
	if input.eql? "move south"
		if playery != MAP_HEIGHT and map[playerx][playery+1].passable?(player)
			playery = playery + 1
			puts "You have moved south."
		else
			puts "You can\'t do that, you are at the bottom of the map." if playerx == MAP_HEIGHT
			puts map[playerx][playery+1].identify + " blocks your path." unless playerx == MAP_HEIGHT
		end
		recognized = true
	end

	if input.eql? "move west"
		if playerx != 0 and map[playerx-1][playery].passable?(player)
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

	if(input.include?("read"))
		obj = input[input.index("read")+5..input.length]
		coords = findObject(obj, playerx, playery, map)
		if coords == nil
			puts obj + " could not be found. Are you close enough to it?"

		else
#			puts "reading sign"

#			puts map[coords[0]][coords[1]].methods.join
#			puts  map[coords[0]][coords[1]].methods.include?("read")

			if not map[coords[0]][coords[1]].methods.join().include?"read"
				puts obj + " does not have text."
			else
				map[coords[0]][coords[1]].read
			end
		end
		recognized = true
	end

	if input.include? "open"
		obj = input[input.index("open")+5..input.length]
                coords = findObject(obj, playerx, playery, map)
                if coords == nil or map[coords[0]][coords[1]].methods.include? "open"
                        puts obj + " either could not be found or opened. Are you close enough to it?"
                else
                        thing = map[coords[0]][coords[1]].open
			#puts "about to start give loop"
			if not thing == nil
			#	puts "starting give loop, first item is " + thing[0].identify
				for x in thing
			#		puts "giving player " + x.identify
					player.give(x)
				end
			end 
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
	abort if input.eql? "exit"
	
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

	if input.include? "drink"
		obj = input[input.index("drink") + 6..input.length]
		index = findObjectFromInventory(obj, player)
		player.getInventory[index].drink(player)
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
	look(playerx, playery, map, player)
	gameloop(playerx, playery, map, player)
end

def look(playerx, playery, map, player)
	puts "You are standing at " + map[playerx][playery].identify unless map[playerx][playery].identify.eql?("nothing")
        puts "To the north of you there is " + map[playerx][playery-1].identify unless playery == 0 or map[playerx][playery-1].identify.eql?("nothing")
        puts "To the west of you there is " + map[playerx-1][playery].identify  unless playerx == 0 or map[playerx-1][playery].identify.eql?("nothing")
        puts "To the south of you there is " + map[playerx][playery+1].identify unless playery == MAP_HEIGHT or map[playerx][playery+1].identify.eql?("nothing")
        puts "To the east of you there is " + map[playerx+1][playery].identify unless playerx == MAP_WIDTH or map[playerx+1][playery].identify.eql?("nothing")
end

look(playerx, playery, map, player)
gameloop(playerx, playery, map, player)
