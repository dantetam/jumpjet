--Declarations
local wP, aP, sP, dP
local player 
local enemies = {}
local bullets = {}

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
		player.velocity = -10
	end
end

function mousePressed(event)
	if event.isPrimaryButtonDown then
		local angle = math.atan2(event.y - player.y, event.x - player.x)
		local b = newProjectile(player.x, player.y, math.cos(angle)*10, math.sin(angle)*10)
		b.type = "player"
		b:rotate(angle)
		table.insert(bullets, b)
	end
end

function newCharacter(x,y)
	--[[
	local ch = display.newGroup()
	ch:insert(display.newRect(x,y,6,12))
	ch:insert(display.newRect(x,y-10,6,6))
	ch.velocity = 0
	return ch
	]]
	local ch = display.newRect(x,y,8,24)
	ch.velocity = 0
	return ch
end

function newProjectile(x,y,velX,velY)
	local b = display.newRect(x,y,10,2)
	b:rotate(math.deg(math.atan2(velY,velX)))
	b.velX = velX
	b.velY = velY
	return b
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
	if (person.y + 5 + person.velocity) < display.contentHeight then
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
	if math.random() < 0.025 and #enemies < 10 then
		table.insert(enemies,newCharacter(600,250))
	end
	--if wP then player:translate(0,-speed) end
	if aP then player:translate(-speed,0) end
	--if sP then player:translate(0,speed) end
	if dP then player:translate(speed,0) end
	gravity(player)
	for i = 1,#enemies do
		gravity(enemies[i])
		if enemies[i].x > player.x then
			enemies[i]:translate(-speed/2,0)
		else
			enemies[i]:translate(speed/2,0)
		end
		if enemies[i].y + 10 < player.y then
			if math.random() < 0.05 then
				enemies[i].velocity = -10
			end
		end
		if math.random() < 0.04 then
			local angle = math.atan2(player.y - enemies[i].y, player.x - enemies[i].x)
			local b = newProjectile(enemies[i].x, enemies[i].y, math.cos(angle)*10, math.sin(angle)*10)
			b.type = "enemy"
			b:rotate(angle)
			table.insert(bullets, b)
		end
	end
	for i = 1,#bullets do
		bullets[i]:translate(bullets[i].velX,bullets[i].velY)
		if bullets[i].type == "enemy" then
			if collide(bullets[i],player) then
				print("Player hit")
			end
		elseif bullets[i].type == "player" then
			for j = 1,#enemies do
				if collide(enemies[j],player) then
					print("Enemy hit")
				end
			end
		end
	end
end

player = newCharacter(50,50)

--Set up keys and mouse events
Runtime:addEventListener("key", keyPressed)
Runtime:addEventListener("mouse", mousePressed)
--Advance the game forward
timer.performWithDelay(1000/40, tick, 0)