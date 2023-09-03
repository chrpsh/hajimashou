function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"
	--unit_0 = Unit(0)
	--unit_1 = Unit(1)

	unit = {}

	max_units = 3
	--for i=0,max_units do
	
	for i=0,max_units do
		unit[i] = Unit(i)
	end

	comm = love.graphics.newFont("trnsgndr.ttf", 14)

	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

	--didattack = false
	step = 0

	moves_log = {}
	moves_log.from = {}
	moves_log.to = {}

	math.randomseed(os.time())

	tick.recur(function () 
        local half_1 = math.random(0,max_units-2)
		local half_2 = math.random(max_units-1,max_units)

		local from = 0
		local to = 0

		if (step % 2 == 0) then
			from = half_1
			to = half_2
		else
			from = half_2
			to = half_1
		end
        attack(from, to)
    end, .54)


    --[[local start = 1
	local show = 20

	if step % 20 == 0 then
		start = start + 20
		show = show + 20
	end]]

	console = {}
	console.start = 1
	console.limit = 20
	console.switch = false

	if console.switch then
		--if step % 10 == 0 then
			console.start = console.start + 20
			console.limit = console.limit + 20
			console.switch = false
		--end
	end

	--if step > 0 then

	--[[if step % 10 == 0 then
		if step ~= 0 then
			console.start = 200
		else 
			console.start = console.start + 3
		end

		--console.start = console.start + 20
		--console.limit = console.limit + 20
	end]]

	--end

end


function set_color(name)
    if name == 'white' then
        love.graphics.setColor(255,255,255)
    elseif name == 'black' then
        love.graphics.setColor(0,0,0)
    elseif name == 'red' then
        love.graphics.setColor(255,0,0)
    elseif name == 'blue' then
        love.graphics.setColor(0,0,255)
    elseif name == 'green' then
        love.graphics.setColor(0,255,0)
    elseif name == 'yellow' then
        love.graphics.setColor(255,255,0)
    end
end



function attack(from, to)
	--attack calc
	unit[from].damage = unit[from].attack - unit[from].sadness
	unit[to].health.lost = unit[from].damage

	unit[to].health.total = unit[to].health.total - unit[to].health.lost--unit[from].damage--unit[from].attack
	unit[from].attack = unit[from].attack + 1
	

	unit[from].exp.new = unit[from].damage
	unit[from].exp.total = unit[from].exp.total + unit[from].exp.new

	if unit[from].exp.total >= unit[from].threshold[unit[from].level] then
		unit[from].level = unit[from].level + 1
		unit[from].log.level[step] = true 
		--unit[from].isLevelup = true
	else
		unit[from].log.level[step] = false
		--unit[from].isLevelup = false
	end

	if not (step % 5 == 0) then
		unit[from].sadness = unit[from].sadness + 1
	else
		unit[from].sadness = 0
	end

	step = step + 1
	--unit[from].isLevelup = false

	--who attacked
	moves_log.to[step] = to
	moves_log.from[step] = from

	--numbers of attack for output
	unit[from].log.attack[step] = unit[from].attack
	unit[from].log.damage[step] = unit[from].damage--unit[from].attack - unit[from].sadness
	unit[from].log.sadness[step] = unit[from].sadness

	--if step > 1 then 
	unit[from].log.exp.new[step] = unit[from].exp.new
	--end
end

--[[function autoBattle()
	tick.recur(function () 
        local half_1 = math.random(0,max_units-2)
		local half_2 = math.random(max_units-1,max_units)

		local from = 0
		local to = 0

		if (step % 2 == 0) then
			from = half_1
			to = half_2
		else
			from = half_2
			to = half_1
		end
        attack(from, to)
    end, 1)
end]]

function love.keypressed(key)
	if key == "space" then
		love.load()
	elseif key == "return" then
		--who attacked
		--local attacker = 0
		--local reciever = 1
		--moves_log.from[step] = attacker
		--moves_log.to[step] = reciever
		--[erform attack]
		
		local half_1 = math.random(0,max_units-2)
		local half_2 = math.random(max_units-1,max_units)

		local from = 0
		local to = 0

		if (step % 2 == 0) then
			from = half_1
			to = half_2
		else
			from = half_2
			to = half_1
		end

		--[[if step % 2 == 0 then
			local from = 0--math.random(0,max_units-2)
			local to = 1--math.random(max_units-1,max_units)
		else
			local from = 2--math.random(0,max_units-2)
			local to = 3--math.random(max_units-1,max_units)
		end]]

		--local from = 0--math.random(0,max_units-2)
		--local to = 1--math.random(max_units-1,max_units)

		--[[if (step % 2 == 0) then
			local from = 1
			local to = 2
		else
			local from = 1
			local to = 2
		end]]

		--[[local yes = false
		repeat
			local tmp = math.random(0,max_units)
			if not tmp == from then
				yes = true
			else
				yes = false
			end
		until(yes)]]

		attack(from, to)

		--[[unit[1].health = unit[1].health - unit[0].attack
		unit[0].attack = unit[0].attack + 1

		if not (step % 5 == 0) then
			unit[0].sadness = unit[0].sadness + 1
		else
			unit[0].sadness = 0
		end

		step = step + 1
		unit[0].log.attack[step] = unit[0].attack
		unit[0].log.damage[step] = unit[0].attack - unit[0].sadness
		unit[0].log.sadness[step] = unit[0].sadness
		
		--[[unit_1.health = unit_1.health - unit_0.attack
		unit_0.attack = unit_0.attack + 1
		if not (step % 5 == 0) then
			unit_0.sadness = unit_0.sadness + 1
		else
			unit_0.sadness = 0
		end
		--unit_1.defense = unit_0.defense + 1
		--didattack = true
		step = step + 1
		unit_0.log.attack[step] = unit_0.attack
		unit_0.log.damage[step] = unit_0.attack - unit_0.sadness
		unit_0.log.sadness[step] = unit_0.sadness]]
	end
end

function love.update(dt)
	tick.update(dt)
end


function switch()
	console.start = console.start + 20
	console.limit = console.limit + 20
end


function love.draw()
	for i=0,max_units do
		unit[i]:draw()
	end

	--local need_switch = false

	--if need_switch then
		--[[if step % 10 == 0 and step ~= 0 then
			console.switch = true
			if console.switch then
				--if step ~= 0 then
				--	console.start = 200
				--	console.switch = false
				--else 
					console.start = console.start + 3
					need_switch = false
				--end
			end
			--need_switch = false

			--console.start = console.start + 20
			--console.limit = console.limit + 20
		end]]

	--end

	--[[unit_0:draw()
	unit_1:draw()]]

	--unit_0 attacked unit_01 with attack and hit N dmg
	
	--[[for i,v in ipairs(moves_log.to) do
		love.graphics.print('to[' .. i .. '] ' .. moves_log.to[i], 100, window_height/2+14*i)
	end]]

	if step % 20 == 0 then
		love.graphics.print('true', 40, window_height/2-14*2)
	else
		love.graphics.print('false', 40, window_height/2-14*2)
	end

	if step ~= 0 then
		love.graphics.print('true', 100, window_height/2-14*2)
	else
		love.graphics.print('false', 100, window_height/2-14*2)
	end

	if console.switch then
		love.graphics.print('true', 400, window_height/2-14*2)
	else
		love.graphics.print('false', 400, window_height/2-14*2)
	end


	love.graphics.print(step, 10, window_height/2-14*2)
	love.graphics.print(table.getn(moves_log.to) .. '/' .. table.getn(moves_log.from), 200, window_height/2-14*2)
		
	--[[if unit[moves_log.from[step-1]]--[[.log.level[step-1] then
		love.graphics.print('true', 100, window_height/2-14*2)
	else
		love.graphics.print('false', 100, window_height/2-14*2)
	end]]
	--love.graphics.print(table.getn(moves_log.to), 100, window_height/2+14*2)

	--love.graphics.print('to[0] ' .. moves_log.to[0], 100, window_height/2+14*0)

	--[[local start = 1
	local show = 20

	if step % 20 == 0 then
		start = start + 20
		show = show + 20
	end]]

	love.graphics.print(console.start .. ' / ' .. console.limit, 300, window_height/2-14*2)

	--[[if step <= 20 then
		for i=1,step do
		end
	elseif step > 20 then
		for i=21,step do
		end
	elseif step > 40 then
		for i=41,step do
		end
	end]]

	--local start = 1

	local limit = 2

	if step >= limit then
		for i=1, limit do
			love.graphics.print('step ' .. step-1 .. ':', 10, window_height/2+14)
			love.graphics.print('u' .. unit[moves_log.from[step-1]].num .. ' → u' .. unit[moves_log.to[step-1]].num, 100, window_height/2+14)
			
			love.graphics.print('step ' .. step .. ':', 10, window_height/2+14*2)
			love.graphics.print('u' .. unit[moves_log.from[step]].num .. ' → u' .. unit[moves_log.to[step]].num, 100, window_height/2+14*2)
		end
	end


	if step ~= 0 then
	--[[if step >= 3 then
		start = 3
	end]]
		if step == 1 then
			--local from = moves_log.from[step]
			--local to = moves_log.to[step]
			love.graphics.print('step ' .. step .. ':', 10, window_height/2+14)
			love.graphics.print('u' .. unit[moves_log.from[step]].num .. ' → u' .. unit[moves_log.to[step]].num, 100, window_height/2+14)
		elseif step == 2 then
			--local from = moves_log.from[step-1]
			--local to = moves_log.to[step-1]
			love.graphics.print('step ' .. step-1 .. ':', 10, window_height/2+14)
			love.graphics.print('u' .. unit[moves_log.from[step-1]].num .. ' → u' .. unit[moves_log.to[step-1]].num, 100, window_height/2+14)
			--local from = moves_log.from[step]
			--local to = moves_log.to[step]
			love.graphics.print('step ' .. step .. ':', 10, window_height/2+14*2)
			love.graphics.print('u' .. unit[moves_log.from[step]].num .. ' → u' .. unit[moves_log.to[step]].num, 100, window_height/2+14*2)
		elseif step >= 3 then
			--local from = moves_log.from[step-2]
			--local to = moves_log.to[step-2]
			love.graphics.print('step ' .. step-2 .. ':', 10, window_height/2+14)
			love.graphics.print('u' .. unit[moves_log.from[step-2]].num .. ' → u' .. unit[moves_log.to[step-2]].num, 100, window_height/2+14)
			--local from = moves_log.from[step-1]
			--local to = moves_log.to[step-1]
			love.graphics.print('step ' .. step-1 .. ':', 10, window_height/2+14*2)
			love.graphics.print('u' .. unit[moves_log.from[step-1]].num .. ' → u' .. unit[moves_log.to[step-1]].num, 100, window_height/2+14*2)
			--local from = moves_log.from[step]
			--local to = moves_log.to[step]
			love.graphics.print('step ' .. step .. ':', 10, window_height/2+14*3)
			love.graphics.print('u' .. unit[moves_log.from[step]].num .. ' → u' .. unit[moves_log.to[step]].num, 100, window_height/2+14*3)
		end
	end

--[[	for i=step-3,step do
	--if didattack then
		--love.graphics.print('step ' .. i .. ': 		' .. 'u_' .. unit_0.num .. ' → u_' .. unit_1.num .. ' w/ ' .. unit_0.log.attack[i] .. ' atk, hit ' .. unit_0.log.damage[i] .. ' dmg', 10, window_height/2+14*i)
		
		local from = moves_log.from[i]
		local from_back = moves_log.from[i]
		local to = moves_log.to[i]

		--love.graphics.print('from: ' .. from .. ' to: ' .. reciever, 100, window_height/2+14*i)

		love.graphics.print('step ' .. i .. ':', 10, window_height/2+14*(i-(console.limit-20)))
		love.graphics.print('u' .. unit[from].num .. ' → u' .. unit[to].num, 100, window_height/2+14*(i-(console.limit-20)))
		love.graphics.print('w/ ' .. unit[from].log.attack[i] .. ' atk', 200, window_height/2+14*(i-(console.limit-20)))
		love.graphics.print('& ' .. unit[from].log.sadness[i] .. ' sad', 300, window_height/2+14*(i-(console.limit-20)))
		set_color('red')
		love.graphics.print('do ' .. unit[from].log.damage[i] .. ' dmg', 400, window_height/2+14*(i-(console.limit-20)))
		set_color('yellow')
		love.graphics.print('+' .. unit[from].log.exp.new[i] .. ' exp', 500, window_height/2+14*(i-(console.limit-20)))

		if unit[from].log.level[i-1] then
			set_color('green')
			love.graphics.print('LEVELUP', 570, window_height/2+14*(i-(console.limit-20)))
		else
			--love.graphics.print('nah', 650, window_height/2+14*i)
		end

		set_color('white')

		
		--[[if step % 10 == 0 then
			switch()
			--console.switch = true
		end]]

		--[[if i % 20 == 0 then
			start = 
			--i = i - 20
		end]]

		--love.graphics.print(table.getn(unit[from].log.level), 700, window_height/2+14*i)
		--love.graphics.print(unit[from].log.level[i], 700, window_height/2+14*i)


	--end
end