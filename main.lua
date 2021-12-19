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

	crit_check = {}
	crit_check_counter = {}
	ch = false

	math.randomseed(os.time())

	--start = false

	--tick.delay(function() start = true end, .6)

	--if start then
		--[[tick.recur(function() 
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
		 end, .6)]]
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
	if not log.crit.a[turn] then
		ch = chance(.2)
		log.crit.a[turn] = true
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
		return 1, 0
	else
		return 0, 1
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

		--wel huh

		--local t_str = 'TURN ' .. turn
		--local t_x = getcenter(t_str)
		--love.graphics.print(t_str, t_x, window_height-14*3)
		
		--[[local n_str = unit[a].name .. ' →→ ' .. unit[b].name
		local n_x = getcenter(n_str)
		love.graphics.print(n_str, n_x, 0)]]

		printstr(unit[a].name .. ' →→ ' .. unit[b].name, 0, 'top')

		if unit[a].log.att[turn-1] ~= nil and unit[b].log.def[turn-1] ~= 0 and unit[a].log.sad[turn-1] ~= nil then
		
			--[[local dmg_str = hp_diff .. ' DMG'
			local dmg_str_cr = hp_diff .. ' DMG (CRITICAL)'

			local dmg_x = getcenter(dmg_str)
			local dmg_x_cr = getcenter(dmg_str_cr)]]

			if ch ~= 1 then
				printstr(hp_diff .. ' DMG', 1, 'top')
				--love.graphics.print(dmg_str_cr, dmg_x_cr, 14)
			else
				printstr(hp_diff .. ' DMG (CRITICAL)', 1, 'top')
				--love.graphics.print(dmg_str, dmg_x, 14)
			end

			--local a,b = whosemove()
			if iscounter() and unit[b].hp > 0 and unit[a].hp > 0 then
				--local c_str = '←← COUNTER ←←'
				--local c_x = getcenter(c_str)
				--love.graphics.print(c_str, c_x, 14*3)
				printstr('←← COUNTER ←←', 3, 'top')

				local hp_diff_2 = 0
				
				if unit[a].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
					hp_diff_2 = unit[a].log.hp[turn-1] - unit[a].log.hp[turn]
				end

				printstr(hp_diff_2 .. ' DMG', 4, 'top')

				--local c_f_str = '← ' .. unit[b].log.att[turn-1] .. ' ATT − ' .. unit[a].log.def[turn-1] .. ' DEF − ' .. unit[b].log.sad[turn-1] .. ' SAD'
				--local c_f_x = getcenter(c_f_str) 
				printstr('← ' .. unit[b].log.att[turn-1] .. ' ATT − ' .. unit[a].log.def[turn-1] .. ' DEF − ' .. unit[b].log.sad[turn-1] .. ' SAD', 1, 'bttm')
				--love.graphics.print(c_f_str, c_f_x, window_height-14)
			end

			--[[if unit[b].def >= unit[a].def and unit[b].hp > 0 and unit[a].hp > 0 then
				local c_str = '←← COUNTER ←←'
				local c_x = getcenter(c_str)
				love.graphics.print(c_str, c_x, 14*3)
				
				local c_hp_diff = 0
				if unit[a].log.hp[turn-1] ~= nil and unit[b].log.hp[turn] ~= nil then
					c_hp_diff = unit[a].log.hp[turn-1] - unit[a].log.hp[turn]
				end

				local c_dmg_str = c_hp_diff .. ' DMG'
				local c_dmg_x = getcenter(c_dmg_str)

				love.graphics.print(c_dmg_str, c_dmg_x, 14*4)

				local c_f_str = '← ' .. unit[b].log.att[turn-1] .. ' ATT − ' .. unit[a].log.def[turn-1] .. ' DEF − ' .. unit[b].log.sad[turn-1] .. ' SAD'
				local c_f_x = getcenter(c_f_str) 
				love.graphics.print(c_f_str, c_f_x, window_height-14)
			end]]

			--[[local f_str_cr = '→ ' .. unit[a].log.att[turn-1]*3 .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD'
			local f_str = '→ ' .. unit[a].log.att[turn-1] .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD'

			local f_x_cr = getcenter(f_str_cr)
			local f_x = getcenter(f_str)]]

			if ch ~= 1 then
				printstr('→ ' .. unit[a].log.att[turn-1] .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD', 2, 'bttm')
				--love.graphics.print(f_str_cr, f_x_cr, window_height-14*2)
			else
				printstr('→ ' .. unit[a].log.att[turn-1]*3 .. ' ATT − ' .. unit[b].log.def[turn-1] .. ' DEF − ' .. unit[a].log.sad[turn-1] .. ' SAD', 2, 'bttm')
				--love.graphics.print(f_str, f_x, window_height-14*2)
			end
		end

		--[[local att_diff = 0
		local def_diff = 0

		if unit[a].log.att[turn-1] ~= nil and unit[a].log.att[turn] ~= nil then
			att_diff = unit[a].log.att[turn] - unit[a].log.att[turn-1]
		end

		if unit[b].log.def[turn-1] ~= nil and unit[b].log.def[turn] ~= nil then
			def_diff = unit[b].log.def[turn] - unit[b].log.def[turn-1]
		end]]

		--[[local d_str = unit[b].name .. ' DIED'
		local d_2_str = unit[b].name .. ' DIED'
		local d_x = (window_width - comm:getWidth(d_str))/2
		local d_2_x = (window_width - comm:getWidth(d_str))/2]]
		
		if unit[b].hp <= 0 then
			printstr(unit[b].name .. ' DIED', 2, 'top')
			--love.graphics.print(d_str, d_x, 14*2)
		elseif unit[b].hp <= 0 then
			printstr(unit[b].name .. ' DIED', 2, 'top')
			--love.graphics.print(d_2_str, d_2_x, 14*2)
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
		--start = true
		--autoplay()
		if showresult then
			nextturn()
			showresult = false
		end
		--local a = 0
		--local b = 1
		local a,b = whosemove()
		if unit[a].hp > 0 and unit[b].hp > 0 then
			attack(b, a)
			if iscounter() then
			--if unit[b].def >= unit[a].def then
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

	showstatus()
end