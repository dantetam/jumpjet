--Declarations
local wP, aP, sP, dP
local player 

--Set up the player
--player:insert(display.newRect(50,50,6,12))
--player:insert(display.newRect(50,40,6,6))

--Functions
function keyPressed(event)
	if event.phase == "down" then
		if event.keyName == "w" then wP = true
		elseif event.keyName == "a" then aP = true
		elseif event.keyName == "s" then sP = true
		elseif event.keyName == "d" then dP = true
		end
	elseif event.phase == "up" then
		if event.keyName == "w" then wP = false
		elseif event.keyName == "a" then aP = false
		elseif event.keyName == "s" then sP = false
		elseif event.keyName == "d" then dP = false
		end
	end
	if event.keyName == "space" and player.velocity == 3 then
		player.velocity = -7
		print("jump")
	end
end

function mousePressed(event)
	if event.isPrimaryButtonDown then
		
	end
end

function newCharacter(x,y)
	local ch = display.newGroup()
	ch:insert(display.newRect(x,y,6,12))
	ch:insert(display.newRect(x,y-10,6,6))
	ch.velocity = 0
	return ch
end

function collide(a,b)
	--Does not account for rotation
	if (a.x + a.width/2 < b.x - b.width/2 or 
		a.y + a.height/2 < b.y - b.height/2 or 
		a.x - a.width/2 > b.x + b.width/2 or 
		a.y - a.height/2 > b.y + b.height/2) then
		return false
	end
    return true
end

function gravity(person)
	if (person.y + 55 + person.velocity) < display.contentHeight then
		person:translate(0,person.velocity) 
	end
	if person.velocity < 3 then
		person.velocity = person.velocity + 1
	else
		person.velocity = 3
	end
end

function tick()
	local speed = 3
	--if wP then player:translate(0,-speed) end
	if aP then player:translate(-speed,0) end
	--if sP then player:translate(0,speed) end
	if dP then player:translate(speed,0) end
	gravity(player)
end

player = newCharacter(50,50)

--Set up keys and mouse events
Runtime:addEventListener("key", keyPressed)
Runtime:addEventListener("mouse", mousePressed)
--Advance the game forward
timer.performWithDelay(1000/40, tick, 0)