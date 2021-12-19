function love.load()
	Object = require "classic"
	tick = require "tick"
	require "unit"

	comm = love.graphics.newFont("trnsgndr.ttf", 14)
	window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

	unit = {}
	
	local names = {
	[0]='XÆA-12', 'RX-78-2'}

	for i=0,1 do
		unit[i] = Unit(i, names[i])
	end

	turn = 1

	log = {}
	log.moves = {}
	log.moves.a = {}
	log.moves.b = {}

	log.crit = {}
	log.crit.a = {}
	log.crit.b = {}

	showresult = false

	rand_chance = 0

	--crit = {a='', b=''}
	crit = {}
	crit.a = 0
	crit.b = 0
	--crit.a = {}
	--crit.b = {}

	crit_check = {}
	crit_check_counter = {}
	ch = 0

	math.randomseed(os.time())
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
    elseif name == 'cyan' then
    	love.graphics.setColor(0,255,255)
    end
end


function chance(x)
	rand_chance = math.random()
	if rand_chance < x then
		return 1
	else
		return 0
	end
end


function attack(a, b)
	--log
	unit[a].log.att[turn-1] = unit[a].att
	unit[a].log.sad[turn-1] = unit[a].sad

	unit[b].log.hp[turn-1] = unit[b].hp
	unit[b].log.def[turn-1] = unit[b].def
	--/log

	--chance of crit
	if not unit[a].log.crit then
	--if not log.crit.a[turn] then
		ch = chance(.2)
		unit[a].log.crit = true
		--log.crit.a[turn] = true
		--crit[a][turn] = true
		unit[a].crit = chance(.2)
		unit[b].crit = chance(.2)
		--crit.a = chance(.2)
		--crit.b = chance(.2)
		--crit[a] = ch --chance(.2)
		--crit[b] = ch --chance(.2)
		--crit.a[step] = chance(.2)
		--crit.b[step] = chance(.2)
	end
	--/

	--calculating damage
	local dmg = unit[a].att + unit[a].att*2*ch - unit[b].def - unit[a].sad

	if dmg < 0 then
		dmg = 0
	end
	--/

	--doing attack on victim's hp
	unit[b].hp = unit[b].hp - dmg
	--/

	--log
	--unit[a].log.hp[turn] = unit[a].hp
	--unit[a].log.def[turn] = unit[a].def	
	unit[a].log.att[turn] = unit[a].att
	unit[a].log.sad[turn] = unit[a].sad

	unit[b].log.hp[turn] = unit[b].hp
	unit[b].log.def[turn] = unit[b].def
	--unit[b].log.att[turn] = unit[b].att
	--unit[b].log.sad[turn] = unit[b].sad

	log.moves.a[turn] = a
	log.moves.b[turn] = b
end


function getcenter(str)
	return (window_width - comm:getWidth(str))/2
end

function nextturn()
	turn = turn + 1
end

function whosemove()
	if (turn % 2 == 0) then
		return 0, 1
	else
		return 1, 0
	end
end

function autoplay()
	tick.recur(function()
		if unit[0].hp > 0 and unit[1].hp > 0 then
			if showresult then
				nextturn()
				showresult = false
			end
			if (turn % 2 == 0) then
				attack(1, 0)
			else
				attack(0, 1)
			end
			showresult = true
		end
	end, .6)
end

function printstr(str, num, pos)
	if pos == 'top' then
		local x = (window_width - comm:getWidth(str))/2
		love.graphics.print(str, x, 0+14*num)
	elseif pos == 'bttm' then
		local x = (window_width - comm:getWidth(str))/2
		love.graphics.print(str, x, window_height-14*num)
	end
end

function showstatus()
	if showresult then
		local a = log.moves.a[turn]
		local b = log.moves.b[turn]
	
		local hp_diff = 0

		if unit[b].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
			hp_diff = unit[b].log.hp[turn-1] - unit[b].log.hp[turn]
		end

		printstr('TURN ' .. turn, 3, 'bttm')

		printstr(unit[a].name .. ' →→ ' .. unit[b].name, 0, 'top')

		if unit[a].log.att[turn-1] ~= nil and unit[b].log.def[turn-1] ~= 0 and unit[a].log.sad[turn-1] ~= nil then
		
			if ch ~= 1 then
				printstr(hp_diff .. ' DMG', 1, 'top')
			else
				printstr(hp_diff .. ' DMG (CRITICAL)', 1, 'top')
			end

			if iscounter() and unit[b].hp > 0 and unit[a].hp > 0 then

				printstr('←← COUNTER ←←', 3, 'top')

				local hp_diff_2 = 0
				
				if unit[a].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
					hp_diff_2 = unit[a].log.hp[turn-1] - unit[a].log.hp[turn]
				end

				printstr(hp_diff_2 .. ' DMG', 4, 'top')

				printstr('← ' .. unit[b].log.att[turn-1] .. ' ATT − ' .. unit[a].log.def[turn-1] .. ' DEF − ' .. unit[b].log.sad[turn-1] .. ' SAD', 1, 'bttm')
			end

			if ch ~= 1 then
				printstr('→ ' .. unit[a].log.att[turn-1] .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD', 2, 'bttm')
			else
				printstr('→ ' .. unit[a].log.att[turn-1]*3 .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD', 2, 'bttm')
			end
		end
		
		if unit[b].hp <= 0 then
			printstr(unit[b].name .. ' DIED', 2, 'top')
		elseif unit[b].hp <= 0 then
			printstr(unit[b].name .. ' DIED', 2, 'top')
		end
	end
end


function iscounter()
	local a,b = whosemove()
	return unit[b].def > unit[a].def
end

function love.keypressed(key)
	if key == "space" then
		love.load()
	elseif key == "return" then
		if showresult then
			nextturn()
			showresult = false
		end
		local a,b = whosemove()
		if unit[a].hp > 0 and unit[b].hp > 0 then
			attack(b, a)
			if iscounter() then
				attack(a, b)
			end
			showresult = true
		end
	end
end


function love.update(dt)
	tick.update(dt)
end


function love.draw()
	for i=0,table.getn(unit) do
		unit[i]:draw()
	end

	local a,b = whosemove()
	
	--[[if log.crit.a[turn] then
		love.graphics.print('log.crit.a: true', window_width/2, window_height/2-28)
	else
		love.graphics.print('log.crit.a: false', window_width/2, window_height/2-28)
	end]]

	if unit[a].log.crit then
		love.graphics.print('unit[a].log.crit: true', window_width/2, window_height/2-28)
	else
		love.graphics.print('unit[a].log.crit: false', window_width/2, window_height/2-28)
	end

	--[[if ch then
		love.graphics.print('ch: true', window_width/2, window_height/2-14)
	else
		love.graphics.print('ch: false', window_width/2, window_height/2-14)
	end]]

	--love.graphics.print('ch: ' .. ch, window_width/2, window_height/2-14)
	--love.graphics.print('crit.a: ' .. crit.a, window_width/2, window_height/2-14*4)
	--love.graphics.print('crit.a: ' .. unit[a].log.crit, window_width/2, window_height/2+14*4)
	--love.graphics.print('crit.b: ' .. crit.b, window_width/2, window_height/2-14*5)

	--[[if crit.a then
		love.graphics.print('crit.a: true', window_width/2, window_height/2+14)
	else
		love.graphics.print('crit.a: false', window_width/2, window_height/2+14)
	end

	if crit.b then
		love.graphics.print('crit.b: true', window_width/2, window_height/2+28)
	else
		love.graphics.print('crit.b: false', window_width/2, window_height/2+28)
	end]]

	
	love.graphics.print(unit[b].att+unit[b].att*2*ch, window_width/2, window_height/2+28*2)
	

	--[[if crit[a] ~= nil and crit[b] ~= nil then
		love.graphics.print('crit[a]: ' .. crit[a], window_width/2, window_height/2)
		love.graphics.print('crit[b]: ' .. crit[b], window_width/2, window_height/2+14)
	end]]

	showstatus()
end